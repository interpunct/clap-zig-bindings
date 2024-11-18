//! this extension lets the host save and load the plugin state with different
//! semantics depending on the context.
//!
//! briefly, when loading a preset or duplicationg a device, the plugin may want
//! to partially load the state and initialize certain things differently, like
//! handling limited resources or fixed connections to external hardware
//! resources.
//!
//! save and load operations may have a different context. all three of these
//! operations should be equivalent:
//! 1. `state_context.load(state.save(), .preset)`
//! 2. `state.load(state_context.save(.preset))`
//! 3. `state_context.load(state_context.save(.preset), .preset)`
//!
//! if in doubt, fall back to `state`.
//!
//! if the plugin implements this extension it is mandatory to also implement
//! the state extension.

const clap = @import("../main.zig");

pub const id = "clap.state-context/2";

pub const Type = enum(u32) {
    /// suitable for storing and loading a state as a preset
    preset = 1,
    /// suitable for duplicating a plugin instance
    duplicate = 2,
    /// suitable for storing and loading a state within a project or song
    project = 3,
};

pub const Plugin = extern struct {
    /// saves the plugin state into `stream` according to `type`. returns true if the state was correctly
    /// saved. note that the result may be loaded by both `state.Plugin.load` and `state_context.Plugin.load`.
    save: *const fn (plugin: *const clap.Plugin, stream: *const clap.OStream, type: Type) callconv(.C) bool,
    /// loads the plugin state from `stream` according to `type`. returns true if the state was correctly
    /// restored. note that the state may have been saved by `state.Plugin.save` or `state_context.Plugin.save`
    /// with a different `type`.
    load: *const fn (plugin: *const clap.Plugin, stream: *const clap.IStream, type: Type) callconv(.C) bool,
};
