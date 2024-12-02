pub const Version = @import("version.zig").Version;
pub const Entry = @import("entry.zig").Entry;
pub extern const clap_entry: Entry;

pub const PluginFactory = @import("factory/plugin.zig").Factory;
pub const preset_discovery = @import("factory/preset_discovery.zig");

pub const Host = @import("host.zig").Host;
pub const Plugin = @import("plugin.zig").Plugin;
pub const Process = @import("process.zig").Process;
pub const AudioBuffer = @import("audio_buffer.zig").AudioBuffer;
pub const events = @import("events.zig");

pub const IStream = @import("stream.zig").IStream;
pub const OStream = @import("stream.zig").OStream;

pub const ext = @import("ext.zig");

/// the clap ABI version
pub const version = Version{ .major = 1, .minor = 2, .revision = 2 };
/// string capacity for names that can be displayed to the user
pub const name_capacity = 256;
/// string capacity for describing a path, like a parameter in a module
/// heirachy or path within a set of nested track groups. this is not
/// a capcity for describing a file path on the disk.
pub const path_capacity = 1024;

/// generic ID type
pub const Id = enum(u32) { invalid_id = @import("std").math.maxInt(u32), _ };

/// fixed point representation of beat time
pub const BeatTime = enum(i64) {
    _,

    pub fn fromBeats(beats: f64) BeatTime {
        return @enumFromInt(@as(i64, @intFromFloat(@round(beats * (1 << 31)))));
    }
};

/// fixed point representation of seconds time
pub const SecTime = enum(i64) {
    _,

    pub fn fromSecs(seconds: f64) SecTime {
        return @enumFromInt(@as(i64, @intFromFloat(@round(seconds * (1 << 31)))));
    }
};

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

test {
    @import("std").testing.refAllDeclsRecursive(@This());
}
