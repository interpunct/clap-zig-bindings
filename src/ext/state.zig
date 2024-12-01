const clap = @import("../main.zig");

pub const id = "clap.state";

pub const Plugin = extern struct {
    save: *const fn (plugin: *const clap.Plugin, stream: *const clap.OStream) callconv(.C) bool,
    load: *const fn (plugin: *const clap.Plugin, stream: *const clap.IStream) callconv(.C) bool,
};

pub const Host = extern struct {
    markDirty: *const fn (host: *const clap.Host) callconv(.C) void,
};
