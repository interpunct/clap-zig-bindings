const clap = @import("../main.zig");

pub const id = "clap.params";

pub const Info = extern struct {
    pub const Flags = packed struct(u32) {
        is_stepped: bool = false,
        is_periodic: bool = false,
        is_hidden: bool = false,
        is_read_only: bool = false,
        is_bypass: bool = false,
        is_automatable: bool = false,
        is_automatable_per_note_id: bool = false,
        is_automatable_per_key: bool = false,
        is_automatable_per_channel: bool = false,
        is_automatable_per_port: bool = false,
        is_modulatable: bool = false,
        is_modulatable_per_note_id: bool = false,
        is_modulatable_per_key: bool = false,
        is_modulatable_per_channel: bool = false,
        is_modulatable_per_port: bool = false,
        requires_process: bool = false,
        is_enum: bool = false,
        _: u15 = 0,
    };

    /// stable parameter identifier. it must never change.
    id: clap.Id,
    flags: Flags,
    /// value is optional and set by the plugin. its purpose is to provide fast
    /// access to the plugin parameter object by caching its pointer.
    /// important:
    ///  - the cookie is invalidated by a full parameter rescan or when the
    ///    plugin is destroyed.
    ///  - the host will either provide the cookie as issued or null in events
    ///    addressing parameters.
    ///  - the plugin must gracefully handle the case of a cookie which is null
    ///  - many plugins will process the parameter events more quickly if the
    ///    host can provide the cookie in a faster time than a hashmap lookup
    ///    per param per event.
    cookie: ?*anyopaque,
    /// the display name. eg: "Volume". this does not need to be unique. do not
    /// include the module text in this. the host should concatenate/format the
    /// module + name in the case where showing the name alone would be too vague
    name: [clap.name_capacity]u8,
    /// the module path containing the parameter, eg: "Oscillators/Wavetable 1".
    /// '/' will be used as a separator to show a tree-like structure.
    module: [clap.path_capacity]u8,
    /// minimum plain value
    min_value: f64,
    /// maximum plain value
    max_value: f64,
    /// default plain value
    default_value: f64,
};

pub const Plugin = extern struct {
    count: *const fn (plugin: *const clap.Plugin) callconv(.C) u32,
    getInfo: *const fn (plugin: *const clap.Plugin, index: u32, info: *Info) callconv(.C) bool,
    getValue: *const fn (plugin: *const clap.Plugin, id: clap.Id, out_value: *f64) callconv(.C) bool,
    valueToText: *const fn (
        plugin: *const clap.Plugin,
        id: clap.Id,
        value: f64,
        out_buffer: [*]u8,
        out_buffer_capacity: u32,
    ) callconv(.C) bool,
    textToValue: *const fn (
        plugin: *const clap.Plugin,
        id: clap.Id,
        value_text: [*:0]const u8,
        out_value: *f64,
    ) callconv(.C) bool,
    flush: *const fn (
        plugin: *const clap.Plugin,
        in: *const clap.events.InputEvents,
        out: *const clap.events.OutputEvents,
    ) callconv(.C) void,
};

pub const Host = extern struct {
    pub const RescanFlags = packed struct(u32) {
        values: bool = false,
        text: bool = false,
        info: bool = false,
        all: bool = false,
        _: u28 = 0,
    };

    pub const ClearFlags = packed struct(u32) {
        all: bool = false,
        automations: bool = false,
        modulations: bool = false,
        _: u29 = 0,
    };

    rescan: *const fn (host: *const clap.Host, flags: RescanFlags) callconv(.C) void,
    clear: *const fn (host: *const clap.Host, id: clap.Id, flags: ClearFlags) callconv(.C) void,
    requestFlush: *const fn (host: *const clap.Host) callconv(.C) void,
};
