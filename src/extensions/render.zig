//! the render extension is used to let the plugin know if it has "realtime"
//! pressure to process or the host know if your plugin must render in
//! "realtime", ex: a plugin acting as a proxy to a hardware device. this
//! extension does not need to be implemented if your plugin's code  does not
//! have different logic for "realtime" and "offline" rendering.

const clap = @import("../main.zig");

pub const id = "clap.render";

pub const Mode = enum(i32) {
    realtime = 0,
    offline = 1,
};

pub const Plugin = extern struct {
    /// return true if the plugin must process in real time
    hasHardRealtimeRequirement: *const fn (plugin: *const clap.Plugin) callconv(.C) bool,
    /// return true if the rendering mode could be applied
    set: *const fn (plugin: *const clap.Plugin, mode: Mode) callconv(.C) bool,
};
