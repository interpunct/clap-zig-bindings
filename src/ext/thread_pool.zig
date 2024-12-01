//! this extension lets the plugin use the host's thread pool.
//!
//! be aware that using a thread pool may break hard real-time rules due to
//! therad synchronization involved. if the host knows that it is running under
//! hard real-time pressure it may decide not to provide this interface.

const clap = @import("../main.zig");

pub const id = "clap.thread-pool";

pub const Plugin = extern struct {
    /// function to be called by the host's thread pool.
    exec: *const fn (plugin: *const clap.Plugin, task_index: u32) callconv(.C) void,
};

pub const Host = extern struct {
    /// schedule `task_count` jobs in the host thread pool. it can't be called
    /// concurrently or from the thread pool. will block until all the tasks are
    /// processed. this must be used exclusivly for real-time processing within the
    /// process call. returns true if the host did execute all the tasks, false if it
    /// rejectecd the request. the host should check that the plugin is within the
    /// process call, and if not, reject the exeec request.
    requestExec: *const fn (host: *const clap.Host, task_count: u32) callconv(.C) bool,
};
