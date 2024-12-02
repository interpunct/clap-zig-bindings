const Plugin = @import("../plugin.zig").Plugin;
const Host = @import("../host.zig").Host;
/// every method must be thread safe.
/// it is very important to be able to scan the plugin as quickly as possible.
/// the host may change the factory's content.
pub const Factory = extern struct {
    pub const id = "clap.plugin-factory";
    /// get the number of available plugins.
    getPluginCount: *const fn (factory: *const Factory) callconv(.C) u32,
    /// retrieve a plugin descriptor by its index. returns null in case of error. the descriptor
    /// must not be freed.
    getPluginDescriptor: *const fn (factory: *const Factory, index: u32) callconv(.C) ?*const Plugin.Descriptor,
    /// create a plugin by it's id. the returned pointer must be freed by
    /// calling `Plugin.destroy`. the plugin is not allowed to use host
    /// callbacks in the create method. returns null in case of error.
    createPlugin: *const fn (
        factory: *const Factory,
        host: *const Host,
        plugin_id: [*:0]const u8,
    ) callconv(.C) ?*const Plugin,
};
