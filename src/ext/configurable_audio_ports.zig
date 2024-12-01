const clap = @import("../main.zig");

pub const id = "clap.configurable-audio-ports/1";

pub const ConfigurationRequest = extern struct {
    is_input: bool,
    port_index: u32,
    channel_count: u32,
    port_type: ?[*:0]const u8,
    port_details: ?*anyopaque,
};

pub const Plugin = extern struct {
    canApplyConfiguration: *const fn (
        plugin: *const clap.Plugin,
        requests: [*]const ConfigurationRequest,
        request_count: u32,
    ) callconv(.C) bool,
    applyConfiguration: *const fn (
        plugin: *const clap.Plugin,
        requests: [*]const ConfigurationRequest,
        request_count: u32,
    ) callconv(.C) bool,
};
