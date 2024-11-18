const Version = @import("version.zig").Version;
pub const Entry = extern struct {
    version: Version,
    init: *const fn (plugin_path: [*:0]const u8) callconv(.C) bool,
    deinit: *const fn () callconv(.C) void,
    /// get the pointer to a factory. returns null if the factory is not provided. the
    /// returned pointer must not be freed by the caller. this function must be thread safe.
    getFactory: *const fn (factory_id: [*:0]const u8) callconv(.C) ?*const anyopaque,
};
