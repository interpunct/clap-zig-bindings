//! this extension lets your plugin hook itself into the host
//! select/pool/epoll/kqueue reactor. this is useful to handle asynchronous i/o
//! on the main thread.

const clap = @import("../main.zig");

pub const id = "clap.posix-fd-support";

/// io event flags. they can be used to form a mask which describes:
/// - which events you are interested in (`Host.registerFd`/`Host.modifyFd`)
/// - which events happened (`Plugin.onFd`)
pub const Flags = packed struct(u32) {
    read: bool = false,
    write: bool = false,
    @"error": bool = false,
    _: u29,
};

pub const Plugin = extern struct {
    /// this callback is "level-triggered". this means it a writable fd will continuously
    /// produce `onFD` events. don't forget to use `Host.modifyFd` to remove the write
    /// notifications once you are done writing.
    onFd: *const fn (plugin: *const clap.Plugin, fd: c_int, flags: Flags) callconv(.C) void,
};

pub const Host = extern struct {
    /// returns true on success
    registerFd: *const fn (host: *const clap.Host, fd: c_int, flags: Flags) callconv(.C) bool,
    /// returns true on success
    modifyFd: *const fn (host: *const clap.Host, fd: c_int, flags: Flags) callconv(.C) bool,
    /// returns true on success
    unregiserFd: *const fn (host: *const clap.Host, fd: c_int) callconv(.C) bool,
};
