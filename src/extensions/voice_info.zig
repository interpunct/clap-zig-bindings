//! this extension indicates the number of voices the synthesizer has. it is
//! useful for the host when performing polyphonic modulations, because the host
//! needs its own voice management and should try to follow what the plugin is
//! doing:
//! - make the host's voice pool coherent with what the plugin has
//! - turn the host's voice management to mono when the plugin is mono

const clap = @import("../main.zig");

pub const id = "clap.voice-info";

pub const Info = extern struct {
    pub const Flags = packed struct(u64) {
        supports_overlapping_notes: bool = false,
        _: u63 = 0,
    };

    /// the number of voices that the patch can use. should not be
    /// confused with the number of active voices. must always be
    /// between [1, `voice_capacity`]. if the `voice_count` is 1 the
    /// plugin is working in mono and the cost can decide to only use
    /// global modulation mapping.
    voice_count: u32,
    /// maximum number of allocated voices
    voice_capacity: u32,
    flags: Flags,
};

pub const Plugin = extern struct {
    /// returns true on success and populates `info.*` with the voice info.
    get: *const fn (plugin: *const clap.Plugin, info: *Info) callconv(.C) bool,
};

pub const Host = extern struct {
    /// informs the host that the voice info has changed
    changed: *const fn (host: *const clap.Host) callconv(.C) void,
};
