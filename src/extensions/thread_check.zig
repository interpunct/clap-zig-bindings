//! CLAP defines two symbolic threads:
//!
//! main-thread:
//!   this is the thread in which most of the interaction between the plugin
//!   and host happens. this will be the same os thread throughout the lifetime
//!   of the plug-in. On mac and windows this must be the thread on which gui
//!   and timer events are received (i.e., the main thread of the program). it
//!   isn't a realtime thread, yet this thread needs to respond fast enough to
//!   allow responsive user interaction, so it is strongly recommended plugins
//!   run long and expensive or blocking tasks such as preset indexing or asset
//!   loading in dedicated background threads started by the plugin.
//!
//! audio-thread:
//!   this thread can be used for realtime audio processing. its execution
//!   should be as deterministic as possible to meet the audio interface's
//!   deadline (can be under 1ms). there are a known set of operations that
//!   should be avoided: heap memory management, contended locks and mutexes,
//!   i/o, waiting, and so forth.
//!
//!   the audio-thread is symbolic, there isn't one os thread that remains the
//!   audio-thread for the plugin lifetime. a host may opt to have a thread pool
//!   and the `clap.Plugin.process` call may be scheduled on different os
//!   threads over time. however, the host must guarantee that a single plugin
//!   instance will not be in two different audio-threads at the same time.
//!
//!   functions marked with audio-thread **ARE NOT CONCURRENT**. the host may
//!   mark any os thread, including the main-thread, as the audio thread, as
//!   long as it can guarantee that only one os thread is the audio-thread at
//!   a time in a plugin instance. the audio-thread can be seen as a concurrency
//!   guard for all functions marked with audio-thread
//!
//!   the real-time constraint on the audio-thread interacts closely with the
//!   render extension. if the plugin does not implement the render extension,
//!   then that plugin must have all audio-thread functions meet the real time
//!   standard. if the plugin does implement the render extension, and returns
//!   true when render mode is set to real-time or if the plugin advertises a
//!   hard real-time requirement, it must also implement these real-time
//!   constraints. hosts also provide functions marked audio-thread. these can
//!   be safely called by a plugin on the audio-thread. therefore hosts must
//!   either implement these functions meeting the real-time constraints or not
//!   process plugins which advertise a hard real-time constraint or don't
//!   implement the render extension. hosts which provide audio-thread functions
//!   outside these conditions may experience inconsistent or inaccurate
//!   rendering.
//!
//! CLAP also tags some functions as thread-safe. functions tagged as
//! thread-safe can be called from any thread unless explicitly counter-
//! indicated, for example `[thread-safe, !audio-thread]`, and my be called
//! concurrently. since a thread-safe function may be called from the
//! audio-thread unless explicitly counter-indicated, it must also meet the
//! real-time constraints as described above.
//!
//! it is highly reccommended that hosts implement this extension.

const clap = @import("../main.zig");

pub const id = "clap.thread-check";

pub const Host = extern struct {
    /// returns true if "this" thread is the main thread
    isMainThread: *const fn (host: *const clap.Host) callconv(.C) bool,
    /// returns true if "this" thread is one of the audio threads.
    isAudioThread: *const fn (host: *const clap.Host) callconv(.C) bool,
};
