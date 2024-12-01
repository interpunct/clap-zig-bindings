const clap = @import("../main.zig");

pub const id = "clap.latency";

pub const Plugin = extern struct {
    /// returns the plugin latency in samples
    get: *const fn (plugin: *const clap.Plugin) callconv(.C) u32,
};

pub const Host = extern struct {
    /// Tell the host the latency changed. the latency is only
    /// allowed to change during `clap.Plugin.activate`. if the
    /// plugin is activated, call `clap.Host.requestRestart`.
    changed: *const fn (host: *const clap.Host) callconv(.C) void,
};
