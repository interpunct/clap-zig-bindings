//! this extension lets the host tell the plugin to display a little color
//! based indication on the parameter. this can be used to indicate:
//! - a physical controller is mapped to a parameter
//! - the parameter is currently playing an automation
//! - the parameter is overriding the automation
//! - etc ...
//!
//! the color semantic depends upon the host and the goal is to have a
//! consistent experience across all plugins.

const clap = @import("../main.zig");

pub const id = "clap.param-indication/4";

pub const AutomationState = enum(u32) {
    /// the host doesn't have an automation for this parameter
    none = 0,
    /// the host has an automation for this parameter but isn't playing it
    present = 1,
    /// the host is playing an automation for this parameter
    playing = 2,
    /// the host is recording an automation for this parameter
    recording = 3,
    /// the host should play an automation for this parameter but
    /// the user has started to adjust this parameter and is
    /// overriding the automation playback
    overriding = 4,
};

pub const Plugin = extern struct {
    /// sets or clears a mapping indication. you can use `color`, `label`, and
    /// `description` (if set) as hints to provide information in the plugin
    /// gui. ex: a highlight color on a knob, a small label on top of a knob
    /// which identifies the hardware controller, a tooltip shown on hover to
    /// describe the current mapping, etc. parameter indications should not be
    /// saved in the plugin context and are off by default.
    setMapping: *const fn (
        plugin: *const clap.Plugin,
        param_id: clap.Id,
        has_mapping: bool,
        color: ?*const clap.Color,
        label: ?[*:0]const u8,
        description: ?[*:0]const u8,
    ) callconv(.C) void,
    /// sets or clears and automation indication. you can use `color`, if set,
    /// as a hint for how  to display the automation indication in the plugin
    /// gui. parameter indications should not be saved in the plugin context and
    /// are off by default.
    setAutomation: *const fn (
        plugin: *const clap.Plugin,
        param_id: clap.Id,
        automation_state: AutomationState,
        color: ?*const clap.Color,
    ) callconv(.C) void,
};
