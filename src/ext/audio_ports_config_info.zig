const clap = @import("../main.zig");

pub const id = "clap.audio-ports-config-info/1";

pub const Plugin = extern struct {
    currentConfig: *const fn (plugin: *const clap.Plugin) callconv(.C) clap.Id,
    get: *const fn (
        plugin: *const clap.Plugin,
        config_id: clap.Id,
        port_index: u32,
        is_input: bool,
        info: *clap.ext.audio_ports.Info,
    ) callconv(.C) bool,
};
