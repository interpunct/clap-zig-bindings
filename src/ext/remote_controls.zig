//! this extension lets the plugin provide a structured way of mapping
//! parameters to a hardware controller. this is done by providing a set of
//! remote control pages organized by section. a page contains up to 8
//! controls, which references parameters using parameter's ids.
//!
//! ```
//! | - [section:main]
//! |     - [name:main] performance controls
//! | - [section:osc]
//! |   | - [name:osc1] osc1 page
//! |   | - [name:osc2] osc2 page
//! |   | - [name:osc-sync] osc sync page
//! |     - [name:osc-noise] osc noise page
//! | - [section:filter]
//! |   | - [name:flt1] filter 1 page
//! |     - [name:flt2] filter 2 page
//! | - [section:env]
//! |   | - [name:env1] env1 page
//! |     - [name:env2] env2 page
//! | - [section:lfo]
//! |   | - [name:lfo1] env1 page
//! |     - [name:lfo2] env2 page
//!   - etc...
//! ```
//!
//! one possible workflow is to have a set of buttons, which correspond to a
//! section. pressing that button once gets you to the first page of the
//! section. press it again to cycle through the section's pages.

const clap = @import("../main.zig");

pub const id = "clap.remote-controls/2";

pub const controls_per_page = 8;

pub const Page = extern struct {
    section_name: [clap.name_capacity]u8,
    page_id: clap.Id,
    page_name: [clap.name_capacity]u8,
    param_ids: [controls_per_page]clap.Id,
    /// this is used to separate device and preset pages.
    /// if true, this page is specific to this preset.
    is_for_preset: bool,
};

pub const Plugin = extern struct {
    /// returns the number of pages.
    count: *const fn (plugin: *const clap.Plugin) callconv(.C) u32,
    /// get a page by its index. returns true on success and stores the result into `page.*`.
    get: *const fn (plugin: *const clap.Plugin, index: u32, page: *Page) callconv(.C) bool,
};

pub const Host = extern struct {
    /// informs the host that the remote controls have changed.
    changed: *const fn (host: *const clap.Host) callconv(.C) void,
    /// suggest a page to the host. for example because it
    /// corresponds to what the user is editing in the plugin gui.
    suggestPage: *const fn (host: *const clap.Host, page_id: clap.Id) callconv(.C) void,
};
