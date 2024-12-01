//! this extension can be used to specify the channel mapping used by the
//! plugin.
//!
//! to have consistent surround features across all plugin instances, here is
//! the proposed workflow:
//! 1. the plugin queries the host preferred channel mapping and adjusts its
//!    configuration to match it.
//! 2. the host checks how the plugin is effectivly configured and honors it.
//!
//! if the host decides to change the project's surround setup:
//! 1. deactivate the plugin.
//! 2. host calls `Plugin.changed`
//! 3. plugin calls `Host.getPreferredChannelMap`
//! 4. plugin eventually calls `Host.changed`
//! 5. host calls `Plugin.getChannelMap` if changed
//! 6. host activates the plugin and can start processing audio
//!
//! if the plugin wants to change its surround setup:
//! 1. plugin calls `clap.Host.requestRestart` if it is active
//! 2. once deactivated the plugin calls `Host.changed`
//! 3. host calls `Plugin.getChannelMap`
//! 4. host activates the plugin and can start processing audio

const clap = @import("../main.zig");

pub const id = "clap.surround/4";

pub const port = "surround";

pub const Channels = packed struct(u64) {
    front_left: bool = false,
    front_right: bool = false,
    front_center: bool = false,
    low_frequency: bool = false,
    back_left: bool = false,
    back_right: bool = false,
    front_left_of_center: bool = false,
    front_right_of_center: bool = false,
    back_center: bool = false,
    side_left: bool = false,
    side_right: bool = false,
    top_center: bool = false,
    front_left_height: bool = false,
    front_center_height: bool = false,
    front_right_height: bool = false,
    rear_left_height: bool = false,
    rear_center_height: bool = false,
    rear_right_height: bool = false,
    _: u46 = 0,
};

pub const Channel = enum(u8) {
    front_left = 0,
    front_right = 1,
    front_center = 2,
    low_frequency = 3,
    back_left = 4,
    back_right = 5,
    front_left_of_center = 6,
    front_right_of_center = 7,
    back_center = 8,
    side_left = 9,
    side_right = 10,
    top_center = 11,
    front_left_height = 12,
    front_center_height = 13,
    front_right_height = 14,
    rear_left_height = 15,
    rear_center_height = 16,
    rear_right_height = 17,
};

pub const Plugin = extern struct {
    /// checks if a given channel setup is supported.
    isChannelSetupSupported: *const fn (plugin: *const clap.Plugin, channels: Channels) callconv(.C) bool,
    /// stores the `Channel` varient of each channel into the
    /// `map` pointer. returns the number of elements stored
    /// into `map`. `map_capacity` must be greater or equal
    /// to the channel count of the given port.
    getChannelMap: *const fn (
        plugin: *const clap.Plugin,
        is_input: bool,
        port_index: u32,
        map: [*]Channel,
        map_capacity: u32,
    ) callconv(.C) u32,
};

pub const Host = extern struct {
    /// informs the host that the channel map has changed. the channel
    /// map can only change when the plugin is not active.
    changed: *const fn (host: *const clap.Host) callconv(.C) void,
};
