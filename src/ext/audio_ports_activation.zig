const clap = @import("../main.zig");
pub const id = "clap.audio-ports-activation/2";

pub const Plugin = extern struct {
    canActivateWhileProcessing: *const fn (plugin: *const clap.Plugin) callconv(.C) bool,
    setActive: *const fn (
        plugin: *const clap.Plugin,
        is_input: bool,
        port_index: u32,
        is_active: bool,
        sample_size: u32,
    ) callconv(.C) bool,
};
