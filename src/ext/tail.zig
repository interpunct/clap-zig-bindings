const clap = @import("../main.zig");

pub const id = "clap.tail";

pub const Plugin = extern struct {
    /// returns the tail length in samples. any value greater than or equal to
    /// `std.math.maxInt(u32)` implies an infinite tail.
    get: *const fn (plugin: *const clap.Plugin) callconv(.C) u32,
};

pub const Host = extern struct {
    /// tell the host that the tail has changed.
    changed: *const fn (host: *const clap.Host) callconv(.C) void,
};
