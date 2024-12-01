//! this extension lets the plugin query info about the track it is on. it is
//! useful when the plugin is created to initialize some parameters (mix, dry,
//! wet, etc) and pick a suitable configuration regarding audio port type and
//! channel count.

const clap = @import("../main.zig");

pub const id = "clap.track-info/1";

pub const Info = extern struct {
    pub const Flags = packed struct(u64) {
        has_track_name: bool = false,
        has_track_color: bool = false,
        has_audio_channel: bool = false,
        /// this plugin is on a return track, initialize with wet 100%
        is_for_return_track: bool = false,
        /// this plugin is on a bus track, initialize with appropriate settings for bus processing
        is_for_bus: bool = false,
        /// this plugin is on the master, initialize with appropriate settings for channel processing
        is_for_master: bool = false,
        _: u58 = 0,
    };

    flags: Flags,
    /// available if flags.has_track_name is true
    name: [clap.name_capacity]u8,
    /// available if flags.has_track_color is true
    color: clap.Color,
    /// available if flags.has_audio_channel is true.
    audio_channel_count: i32,
    /// available if flags.has_audio_channel is true.
    audio_port_type: ?[*:0]const u8,
};

pub const Plugin = extern struct {
    /// called by the host when the track info changes
    changed: *const fn (plugin: *const clap.Plugin) callconv(.C) void,
};

pub const Host = extern struct {
    /// get info about the track the plugin belongs to. returns
    /// true on success and stores the track info into `info.*`.
    get: *const fn (host: *const clap.Host, info: *Info) callconv(.C) bool,
};
