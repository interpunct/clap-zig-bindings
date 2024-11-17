const clap = @import("../main.zig");

pub const id = "clap.note-name";

pub const NoteName = extern struct {
    name: [clap.name_capacity]u8,
    /// -1 for every port
    port: i16,
    /// -1 for every key
    key: i16,
    /// -1 for every channel
    channel: i16,
};

pub const Plugin = extern struct {
    count: *const fn (plugin: *const clap.Plugin) callconv(.C) u32,
    /// returns true on success and stores result into name.*
    get: *const fn (plugin: *const clap.Plugin, index: u32, name: *NoteName) callconv(.C) bool,
};

pub const Host = extern struct {
    /// informs the host that the note names have changed.
    changed: *const fn (host: *const clap.Host) callconv(.C) void,
};
