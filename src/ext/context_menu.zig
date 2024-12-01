const clap = @import("../main.zig");

pub const id = "clap.context-menu/1";

pub const Target = extern struct {
    pub const Kind = enum(u32) { global, param };

    kind: Kind,
    id: clap.Id,
};

pub const Builder = extern struct {
    pub const Kind = enum(u32) {
        /// data: `Entry`
        entry = 0,
        /// data: `CheckEntry`
        check_entry = 1,
        /// data: `null`
        separator = 2,
        /// data: `Submenu`
        begin_submenu = 3,
        /// data: null,
        end_submenu = 4,
        /// data: `Title`
        title = 5,
    };

    pub const Entry = extern struct {
        label: [*:0]const u8,
        is_enabled: bool,
        action_id: clap.Id,
    };

    pub const CheckEntry = extern struct {
        label: [*:0]const u8,
        is_enabled: bool,
        is_checked: bool,
        action_id: clap.Id,
    };

    pub const Submenu = extern struct {
        label: [*:0]const u8,
        is_enabled: bool,
    };

    pub const Title = extern struct {
        title: [*:0]const u8,
        is_enabled: bool,
    };

    context: *anyopaque,
    addItem: *const fn (builder: *const Builder, kind: Kind, data: ?*anyopaque) callconv(.C) bool,
    supports: *const fn (builder: *const Builder, kind: Kind) callconv(.C) bool,
};

pub const Plugin = extern struct {
    populate: *const fn (plugin: *const clap.Plugin, target: ?*const Target, builder: *const Builder) callconv(.C) bool,
    perform: *const fn (plugin: *const clap.Plugin, target: ?*const Target, action_id: clap.Id) callconv(.C) bool,
};

pub const Host = extern struct {
    populate: *const fn (host: *const clap.Host, target: ?*const Target, builder: *const Builder) callconv(.C) bool,
    perform: *const fn (host: *const clap.Host, target: ?*const Target, action_id: clap.Id) callconv(.C) bool,
    canPopup: *const fn (host: *const clap.Host) callconv(.C) bool,
    popup: *const fn (
        host: *const clap.Host,
        target: ?*const Target,
        screen_index: i32,
        x: i32,
        y: i32,
    ) callconv(.C) bool,
};
