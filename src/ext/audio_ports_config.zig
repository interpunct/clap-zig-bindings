const clap = @import("../main.zig");

pub const id = "clap.audio-ports-config";

pub const Config = extern struct {
    id: clap.Id,
    name: [clap.name_capacity]u8,

    input_port_count: u32,
    output_port_count: u32,

    has_main_input: bool,
    main_input_channel_count: u32,
    main_input_port_type: ?[*:0]const u8,

    has_main_output: bool,
    main_output_channel_count: u32,
    main_output_port_type: ?[*:0]const u8,
};

pub const Plugin = extern struct {
    count: *const fn (plugin: *const clap.Plugin) callconv(.C) u32,
    get: *const fn (plugin: *const clap.Plugin, index: u32, config: *Config) callconv(.C) bool,
    select: *const fn (plugin: *const clap.Plugin, config_id: clap.Id) callconv(.C) bool,
};

pub const Host = extern struct {
    rescan: *const fn (host: *const clap.Host) callconv(.C) void,
};
