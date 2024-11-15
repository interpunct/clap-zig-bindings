pub const AudioBuffer = extern struct {
    /// either data32 or data64 will be set.
    data32: ?[*][*]f32,
    data64: ?[*][*]f64,
    channel_count: u32,
    /// latency from/to the audio interface.
    latency: u32,
    constant_mask: u64,
};
