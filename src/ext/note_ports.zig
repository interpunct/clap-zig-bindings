//! this extension provides a way for the plugin to describe its current note
//! ports. if the plugin does not implement this extension it won't have note
//! input or output. the plugin ins only allowed to change its note ports
//! configuration while it is deactivated.

const clap = @import("../main.zig");

pub const id = "clap.note-ports";

pub const Info = extern struct {
    pub const Dialects = packed struct(u32) {
        clap: bool = false,
        /// no polyphonic expression
        midi: bool = false,
        /// with polyphonic expression
        midi_mpe: bool = false,
        midi2: bool = false,
        _: u28 = 0,
    };

    pub const Dialect = enum(u32) {
        clap = @bitCast(Dialects{ .clap = true }),
        midi = @bitCast(Dialects{ .midi = true }),
        midi_mpe = @bitCast(Dialects{ .midi_mpe = true }),
        midi2 = @bitCast(Dialects{ .midi2 = true }),
    };

    /// identifies a port and must be stable.
    /// id may overlap between input and output ports.
    id: clap.Id,
    supported_dialects: Dialects,
    preferred_dialect: Dialect,
    /// displayable name
    name: [clap.name_capacity]u8,
};

pub const Plugin = extern struct {
    count: *const fn (plugin: *const clap.Plugin, is_input: bool) callconv(.C) u32,
    get: *const fn (plugin: *const clap.Plugin, index: u32, is_input: bool, info: *Info) callconv(.C) bool,
};

pub const Host = extern struct {
    pub const RescanFlags = packed struct(u32) {
        all: bool = false,
        names: bool = false,
        _: u30 = 0,
    };

    supportedDialects: *const fn (host: *const clap.Host) callconv(.C) Info.Dialects,
    rescan: *const fn (host: *const clap.Host, flags: RescanFlags) callconv(.C) void,
};
