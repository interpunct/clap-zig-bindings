pub const IStream = extern struct {
    /// number of bytes read, end of file, or an unknown error.
    pub const Result = enum(i64) { read_error = -1, end_of_file = 0, _ };

    context: *anyopaque,
    read: *const fn (
        stream: *const IStream,
        buffer: *anyopaque,
        size: u64,
    ) callconv(.C) Result,
};

pub const OStream = extern struct {
    /// number of bytes written or an unknown error.
    pub const Result = enum(i64) { write_error = -1, _ };

    context: *anyopaque,
    write: *const fn (
        stream: *const OStream,
        bufer: *const anyopaque,
        size: u64,
    ) callconv(.C) Result,
};
