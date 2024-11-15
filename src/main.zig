pub const Version = @import("version.zig").Version;
pub const Entry = @import("entry.zig").Entry;
pub const clap_entry = @import("entry.zig").clap_entry;

pub const PluginFactory = @import("plugin_factory.zig").PluginFactory;
// TODO: const preset_discovery = @import("preset_discovery.zig");

pub const Host = @import("host.zig").Host;
pub const Plugin = @import("plugin.zig").Plugin;
pub const Process = @import("process.zig").Process;
pub const AudioBuffer = @import("audio_buffer.zig").AudioBuffer;
pub const Event = @import("events.zig").Event;

/// the current clap version
pub const clap_version = Version{ .major = 1, .minor = 2, .revision = 2 };
/// string capacity for names that can be displayed to the user
pub const name_capacity = 256;
/// string capacity for describing a path, like a parameter in a module
/// heirachy or path within a set of nested track groups. this is not
/// a capcity for describing a file path on the disk.
pub const path_capacity = 1024;

pub const ClapId = enum(u32) {
    invalid_id = @import("std").math.maxInt(u32),
    _,
};

pub const BeatTime = enum(i64) { _ };
pub const SecTime = enum(i64) { _ };

pub const Timestamp = enum(u64) { unknown = 0, _ };

pub const Color = extern struct {
    alpha: u8,
    red: u8,
    green: u8,
    blue: u8,
};

/// a pair of plugin ABI and plugin identifier.
pub const UniversalPluginId = extern struct {
    /// plugin ABI name, in lowercase
    /// eg: "clap", "vst3", "vst2", "au", ...
    abi: [*:0]const u8,
    /// plugin ID, formatted as follows:
    ///
    /// clap: use the plugin id
    ///   eg: "com.u-he.diva"
    ///
    /// au: format the string like "type:subt:manu"
    ///   eg: "aumu:SgXT:VmbA"
    ///
    /// vst2: print the id as a signed 32-bits integer
    ///   eg: "-4382976"
    ///
    /// vst3: pring the id as a standard UUID
    ///   eg: "123e4567-e89b-12d3-a456-426614174000"
    id: [*:0]const u8,
};

pub const IStream = extern struct {
    context: *anyopaque,
    /// returns the number of bytes read. 0 indicates end of file and -1 a read error.
    read: *const fn (stream: *const IStream, buffer: *anyopaque, size: u64) callconv(.C) i64,
};

pub const OStream = extern struct {
    context: *anyopaque,
    write: *const fn (stream: *const OStream, bufer: *const anyopaque, size: u64) callconv(.C) i64,
};

pub const extensions = @import("extensions.zig");
