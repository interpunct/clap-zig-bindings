const clap = @import("../main.zig");

pub const id = "clap.preset-load/2";

pub const Plugin = extern struct {
    /// loads a preset in the plugin's native preset file format from a
    /// location. the preset discovery provider defines the location and
    /// load_key to be passed to this function. returns true on success.
    fromLocation: *const fn (
        plugin: *const clap.Plugin,
        location_kind: clap.preset_discovery.Location.Kind,
        location: [*:0]const u8,
        load_key: [*:0]const u8,
    ) callconv(.C) bool,
};

pub const Host = extern struct {
    /// called if `Plugin.fromLocation` failed. if `os_error` is not applicable
    /// set it to a non-error value, eg: 0 on unix and windows.
    onError: *const fn (
        host: *const clap.Host,
        location_kind: clap.preset_discovery.Location.Kind,
        location: [*:0]const u8,
        load_key: [*:0]const u8,
        os_error: i32,
        msg: [*:0]const u8,
    ) callconv(.C) void,
    /// informs the host that the following preset has been loaded. the purpose
    /// of this is to keep the host preset browser and plugin preset browser in
    /// sync. if the preset was loaded from a container file, then `load_key`
    /// must be non-null, otherwise it must be null.
    loaded: *const fn (
        host: *const clap.Host,
        location_kind: clap.preset_discovery.Location.Kind,
        location: [*:0]const u8,
        load_key: ?[*:0]const u8,
    ) callconv(.C) void,
};
