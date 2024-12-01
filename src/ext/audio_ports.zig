//! this extension provides a way for the plugin to describe its current audio
//! ports. if the plugin does not implement this extension it will not have
//! audio ports. 32 bits support is required for both host and plugins. 64 bits
//! audio is optional. the plugin is only allowed to change its ports
//! configuration while it is deactivated.

const clap = @import("../main.zig");

pub const id = "clap.audio-ports";
pub const port_mono = "mono";
pub const port_stereo = "stereo";

pub const Info = extern struct {
    pub const Flags = packed struct(u32) {
        /// this port is the main audio input or output. there can only
        /// be one main input or output. main port must be at index 0.
        is_main: bool = false,
        /// this port can be used with 64 bits audio
        supports_64bits: bool = false,
        /// 64 bits audio is preferred with this port
        prefers_64bits: bool = false,
        /// this port must be used with the same sample size as all other ports which have
        /// this flag. in other words if all ports have this flag then the plugin may either
        /// be used entirely with 64 bits audio or 32 bits audio, but it can't be mixed.
        requires_common_sample_size: bool = false,
        _: u28 = 0,
    };

    /// id identifies a port and must be stable.
    /// id may overlap between input and output ports.
    id: clap.Id,
    /// displayable name
    name: [clap.name_capacity]u8,

    flags: Flags,
    channel_count: u32,

    /// if null or empty then it is unspecified. this field  can be
    /// compared against `port_mono` and `port_stereo`. extensions can
    /// also provide its own port type and way to inspect the channels.
    /// see the surround and ambisonic extensions for examples.
    port_type: ?[*:0]const u8,

    /// in-place processing: allow the host to use the same buffer for input
    /// output. if supported set the id. if not supported set to `.invalid_id`
    in_place_pair: clap.Id,
};

pub const Plugin = extern struct {
    /// number of ports for either input or output
    count: *const fn (plugin: *const clap.Plugin, is_input: bool) callconv(.C) u32,
    /// get info about an audio port. returns true on success and stores the result into `info`.
    get: *const fn (plugin: *const clap.Plugin, index: u32, is_input: bool, info: *Info) callconv(.C) bool,
};

pub const Host = extern struct {
    pub const RescanFlags = packed struct(u32) {
        /// the ports name changed, the host can scan them right away.
        names: bool = false,
        /// the flags changed
        flags: bool = false,
        /// the channel_count changed
        channel_count: bool = false,
        /// the port type changed
        port_type: bool = false,
        /// the in-place pair changed
        in_place_pair: bool = false,
        /// the list of ports have changed: entries have been removed/added.
        list: bool = false,
        _: u26 = 0,
    };

    pub const RescanFlag = enum(u32) {
        names = @bitCast(RescanFlags{ .names = true }),
        flags = @bitCast(RescanFlags{ .flags = true }),
        channel_count = @bitCast(RescanFlags{ .channel_count = true }),
        port_type = @bitCast(RescanFlags{ .port_type = true }),
        in_place_pair = @bitCast(RescanFlags{ .in_place_pair = true }),
        list = @bitCast(RescanFlags{ .list = true }),
    };

    /// checks if the host allows a plugin to change a given aspect of the audio ports definition.
    isRescanFlagSupported: *const fn (host: *const clap.Host, flag: RescanFlag) callconv(.C) bool,
    /// rescan the full list of audio ports according to the flags. it is illegal to ask the host to
    /// rescan with a flag that is not supported. certain flags require the plugin to be deactivated.
    rescan: *const fn (host: *const clap.Host, flags: RescanFlags) callconv(.C) void,
};
