const clap = @import("../main.zig");

pub const id = "clap.event-registry";

pub const Host = extern struct {
    /// queries an event space id. the space id 0 is reserved for CLAP's core events. returns false
    /// and sets space_id.* to `std.math.maxInt(u16)` of the space name is unknown to the host.
    query: *const fn (host: *const clap.Host, space_name: [*:0]const u8, space_id: *u16) callconv(.C) bool,
};
