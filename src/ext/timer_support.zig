const clap = @import("../main.zig");

pub const id = "clap.timer-support";

pub const Plugin = extern struct {
    onTimer: *const fn (plugin: *const clap.Plugin, timer_id: clap.Id) callconv(.C) void,
};

pub const Host = extern struct {
    /// registers a periodic timer. the host may adjust the period if it is under
    /// a certain threshold. 30 hz should be allowed. returns true on success.
    registerTimer: *const fn (host: *const clap.Host, period_ms: u32, timer_id: *clap.Id) callconv(.C) bool,
    /// returns true on success.
    unregisterTimer: *const fn (host: *const clap.Host, timer_id: clap.Id) callconv(.C) bool,
};
