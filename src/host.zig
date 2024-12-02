const Version = @import("version.zig").Version;
pub const Host = extern struct {
    clap_version: Version,
    /// reserved pointer for the host
    host_data: *anyopaque,
    /// eg: "Bitwig Studio"
    name: [*:0]const u8,
    /// eg: "Bitwig GmbH"
    vendor: ?[*:0]const u8,
    /// eg: "https://bitwig.com"
    url: ?[*:0]const u8,
    /// eg: "4.3"
    version: [*:0]const u8,
    /// query an extension. the returned pointer is owned by the host. it is forbidden to
    /// call it before `Plugin.init`. you may call in within `Plugin.init` call and after.
    getExtension: *const fn (host: *const Host, id: [*:0]const u8) callconv(.C) ?*const anyopaque,
    /// request the host to deactivate then reactivate
    /// the plugin. the host may delay this operation.
    requestRestart: *const fn (host: *const Host) callconv(.C) void,
    /// request the host to start processing the plugin. this is useful
    /// if you have external IO and need to wake the plugin up from "sleep"
    requestProcess: *const fn (host: *const Host) callconv(.C) void,
    /// request the host to schedule a call to `Plugin.onMainThread`, on the main thread.
    requestCallback: *const fn (host: *const Host) callconv(.C) void,
};
