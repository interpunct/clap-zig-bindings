pub const IStream = extern struct {
    context: *anyopaque,
    /// returns the number of bytes read. 0 indicates end of file and -1 a read error.
    read: *const fn (stream: *const IStream, buffer: *anyopaque, size: u64) callconv(.C) i64,
};

pub const OStream = extern struct {
    context: *anyopaque,
    /// returns the number of bytes written. -1 indicates a write error
    write: *const fn (stream: *const OStream, bufer: *const anyopaque, size: u64) callconv(.C) i64,
};
