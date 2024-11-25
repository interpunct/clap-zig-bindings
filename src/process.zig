const events = @import("events.zig");
const AudioBuffer = @import("audio_buffer.zig").AudioBuffer;

pub const Process = extern struct {
    pub const Status = enum(i32) {
        /// processing failed. the output buffer must be discarded.
        @"error" = 0,
        /// processing succeeded, keep processing.
        @"continue" = 1,
        /// processing succeeded, keep processing if the output is not quiet.
        continue_if_not_quiet = 2,
        /// rely upon the plugin's tail to determine if the plugin should continue to process.
        tail = 3,
        /// processing succeeded but no more processing is required,
        /// until the next event or variation in audio input.
        sleep = 4,
    };

    /// if not unavailable must be non-negative
    pub const SteadyTime = enum(i64) { unavailable = -1, _ };

    /// a steady sample time counter.
    /// this field can be used to claculate the sleep duration between two process calls.
    /// this value may be specific to this plugin instance and have no relation to what
    /// other plugin instances may receive. must be increased by at least `frames_count`
    ///  for the next call to process.
    steady_time: SteadyTime,
    /// number of frames to process.
    frames_count: u32,
    /// time info at sample 0. if null then this is a free
    /// running host. no transport events will be provided
    transport: ?*const events.Transport,
    audio_inputs: [*]const AudioBuffer,
    audio_outputs: [*]AudioBuffer,
    audio_inputs_count: u32,
    audio_outputs_count: u32,
    /// input event list. the host will deliver these sorted in sample order.
    in_events: *const events.InputEvents,
    /// output event list. the plugin must insert events in sample sorted order.
    out_events: *const events.OutputEvents,
};
