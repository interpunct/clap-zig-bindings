//! this extension defines how a plugin will present it's gui. there are two
//! approaches:
//! 1. the plugin creates a window and embeds it into the host's window
//! 2. the plugin creates a floating window
//!
//! embedding the window gives more control to the host and feels more
//! integrated. floating windows are sometimes the only option due to technical
//! limitations.
//!
//! showing the gui works as following:
//! 1. `Plugin.isApiSupported`, check what can work
//! 2. `Plugin.create`, allocates gui resources
//! 3. if the plugin is floating
//!    -> `Plugin.setTransient`
//!    -> `Plugin.suggestTile`
//!    else, the plugin is not floating
//!    -> `Plugin.setScale`
//!    -> `Plugin.canResize`
//!    -> if resizable and has previously known size, `Plugin.setSize`
//!       else, `Plugin.getSize`
//!    -> `Plugin.setParent`
//! 4. `Plugin.show`
//! 5. `Plugin.hide`/`Plugin.show`...
//! 6. `Plugin.destroy` when done with the gui
//!
//! resizing the window (initiated by the plugin, if embedded):
//! 1. plugin calls `Host.requestResize`
//! 2. if that returns true the new size is accepted. the host does not have to
//!    call `Plugin.setSize`. if the host returns false the new size is rejected
//!
//! resizing the window (drag, if embeded):
//! 1. only possible if `Plugin.canResize` returns true
//! 2. mouse drag -> new_size
//! 3. `Plugin.adjustSize(new_size)` -> working_size
//! 4. `Plugin.setSize(working_size)`

const clap = @import("../main.zig");

pub const id = "clap.gui";

/// if your windowing api is not listed here please open an issue in the CLAP
/// repository and they will figure it out.
/// https://github.com/free-audio/clap/issues/new
pub const window_api = struct {
    /// uses physical size
    /// embed using https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setparent
    pub const win32 = "win32";
    /// uses logical size, don't call `Plugin.setScale`
    pub const cocoa = "cocoa";
    /// uses physical size
    /// embed using https://specifications.freedesktop.org/xembed-spec/xembed-spec-latest.html
    pub const x11 = "x11";
    /// uses physical size
    /// embed is currently not supported, use floating windows
    pub const wayland = "wayland";
};

/// represent a window reference
pub const Window = extern struct {
    /// one of `window_api`
    api: [*:0]const u8,
    data: extern union {
        cocoa: *anyopaque,
        x11: c_ulong,
        win32: *anyopaque,
        /// for anything defined outside of clap
        ptr: *anyopaque,
    },
};

pub const ResizeHints = extern struct {
    can_resize_horizontally: bool,
    can_resize_vertically: bool,

    /// only if can resize horizontally and vertically
    preserve_aspect_ratio: bool,
    aspect_ratio_width: u32,
    aspect_ratio_height: u32,
};

pub const Plugin = extern struct {
    isApiSupported: *const fn (plugin: *const clap.Plugin, api: [*:0]const u8, is_floating: bool) callconv(.C) bool,
    /// returns true if the plugin has a preferred api. the host has no obligation to honor the plugin's preference,
    /// this is just a hint. `api` should be explicitly assigned as a pinter to one of the `window_api.*` constants,
    /// not copied.
    getPreferredApi: *const fn (plugin: *const clap.Plugin, api: *[*:0]const u8, is_floating: *bool) callconv(.C) bool,
    /// create and allocate all resources needed for the gui.
    /// if `is_floating` is true then the window will not be managed by the host. the plugin can set its window
    /// to stay above the parent window (see `setTransient`). `api` may be null or blank for floating windows.
    /// if `is_floating` is false then the plugin has to embed its window into the parent window (see `setParent`).
    /// after this call the gui may not be visible yet, don't forget to call `show`.
    /// returns true if the gui is successfully created.
    create: *const fn (plugin: *const clap.Plugin, api: ?[*:0]const u8, is_floating: bool) callconv(.C) bool,
    /// free all resources associated with the gui
    destroy: *const fn (plugin: *const clap.Plugin) callconv(.C) void,
    /// set the absolute gui scaling factor, overriding any os info. should not be
    /// used if the windowing api relies upon logical pixels. if the plugin prefers
    /// to work out the saling factor itself by quering the os directly, then ignore
    /// the call. scale of 2 means 200% scaling. returns true when scaling could be
    /// applied. returns false when the call was ignored or scaling was not applied.
    setScale: *const fn (plugin: *const clap.Plugin, scale: f64) callconv(.C) bool,
    /// get the current size of the plugin gui. `Plugin.create` must have been called prior to
    /// asking for the size. returns true and populates `width.*` and `height.*` if the plugin
    /// successfully got the size.
    getSize: *const fn (plugin: *const clap.Plugin, width: *u32, height: *u32) callconv(.C) bool,
    /// returns true if the window is resizable (mouse drag)
    canResize: *const fn (plugin: *const clap.Plugin) callconv(.C) bool,
    /// returns true and populates `hints.*` if the plugin can provide hints on how to resize the window.
    getResizeHints: *const fn (plugin: *const clap.Plugin, hints: *ResizeHints) callconv(.C) bool,
    /// if the plugin gui is resizable, then the plugin will calculate the closest usable size which
    /// fits the given size. this method does not resize the gui. returns true and adjusts `width.*`
    /// and `height.*` if the plugin could adjust the given size.
    adjustSize: *const fn (plugin: *const clap.Plugin, width: *u32, height: *u32) callconv(.C) bool,
    /// sets the plugin's window size. returns true if the
    /// plugin successfully resized its window to the given size.
    setSize: *const fn (plugin: *const clap.Plugin, width: u32, height: u32) callconv(.C) bool,
    /// embeds the plugin window into the given window. returns true on success.
    setParent: *const fn (plugin: *const clap.Plugin, window: *const Window) callconv(.C) bool,
    /// sets the plugin window to stay above the given window. returns true on success.
    setTransient: *const fn (plugin: *const clap.Plugin, window: *const Window) callconv(.C) bool,
    /// suggests a window title. only for floating windows.
    suggestTitle: *const fn (plugin: *const clap.Plugin, title: [*:0]const u8) callconv(.C) bool,
    /// show the plugin window. returns true on success.
    show: *const fn (plugin: *const clap.Plugin) callconv(.C) bool,
    /// hide the plugin window. this method does not free the
    /// resources, just hides the window content, yet it may be
    /// a good idea to stop painting timers. returns true on success.
    hide: *const fn (plugin: *const clap.Plugin) callconv(.C) bool,
};

pub const Host = extern struct {
    /// the host should call `Plugin.getResizeHints` again.
    resizeHintsChanged: *const fn (host: *const clap.Host) callconv(.C) void,
    /// request the host to resize the client area to width, height. returns true if the new size
    /// is accepted, false otherwise. the host does not have to call `Plugin.setSize`.
    ///
    /// NOTE: if not called from the main thread, then a return value only means the host
    /// acknowledged the request and will process it asynchronously. if the request then
    /// can't be satisfied then the host will call `Plugin.setSize` to revert the operation.
    requestResize: *const fn (host: *const clap.Host, width: u32, height: u32) callconv(.C) bool,
    /// request the host to show the plugin gui. returns true on success.
    requestShow: *const fn (host: *const clap.Host) callconv(.C) bool,
    /// request the host to hide the plugin gui. returns true on success.
    requestHide: *const fn (host: *const clap.Host) callconv(.C) bool,
    /// the floating window has been closed or the connection to the gui has been lost.
    /// if `was_destroyed` is true then the host must call `Plugin.destroy` to acknowledge
    /// the gui destruction.
    closed: *const fn (host: *const clap.Host, was_destroyed: bool) callconv(.C) void,
};
