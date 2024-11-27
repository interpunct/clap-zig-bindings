const Version = @import("version.zig").Version;
const Process = @import("process.zig").Process;

pub const Plugin = extern struct {
    pub const Descriptor = extern struct {
        clap_version: Version,
        /// arbitrary string, should be unique to plugin.
        /// encouraged to use reverse URI, eg: "com.u-he.diva"
        id: [*:0]const u8,
        /// eg: "Diva"
        name: [*:0]const u8,
        /// eg: "u-he"
        vendor: ?[*:0]const u8,
        /// eg: "https://u-he.com/products/diva/"
        url: ?[*:0]const u8,
        /// eg: "https://dl.u-he.com/manuals/plugins/diva/Diva-user-guide.pdf"
        manual_url: ?[*:0]const u8,
        /// eg: "https://u-he.com/support/"
        support_url: ?[*:0]const u8,
        /// arbitrary string, useful for hosts to be able
        /// to understand and compare to version strings.
        /// a regex-like expression which is likely to be
        /// understood by most hosts:
        /// MAJOR(.MINOR(.REVISION)?)?( (Alpha|Beta) XREV)?
        /// eg: "1.4.4"
        version: ?[*:0]const u8,
        /// eg: "The spirit of analogue"
        description: ?[*:0]const u8,
        /// arbitrary list of keywords. they can be used by the host indexer
        /// to classify the plugin. for standard features see `Plugin.features`.
        features: [*:null]const ?[*:0]const u8,
    };

    pub const features = struct {
        // categories
        pub const instrument = "instrument";
        pub const audio_effect = "audio-effect";
        pub const note_effect = "note-effect";
        pub const note_detector = "note-detector";
        pub const analyzer = "analyzer";

        // sub-categories
        pub const synthesizer = "synthesizer";
        pub const sampler = "sampler";
        pub const drum = "drum";
        pub const drum_machine = "drum-machine";

        pub const filter = "filter";
        pub const phaser = "phaser";
        pub const equalizer = "equalizer";
        pub const deesser = "de-esser";
        pub const phase_vocoder = "phase-vocoder";
        pub const granular = "granular";
        pub const frequency_shifter = "frequency-shifter";
        pub const pitch_shifter = "pitch-shifter";

        pub const distortion = "distortion";
        pub const transient_shaper = "transient-shaper";
        pub const compressor = "compressor";
        pub const expander = "expander";
        pub const gate = "gate";
        pub const limiter = "limiter";

        pub const flanger = "flanger";
        pub const chorus = "chorus";
        pub const delay = "delay";
        pub const reverb = "reverb";

        pub const tremolo = "tremolo";
        pub const glitch = "glitch";

        pub const utility = "utility";
        pub const pitch_correction = "pitch-correction";
        pub const restoration = "restoration";

        pub const multi_effects = "multi-effects";

        pub const mixing = "mixing";
        pub const mastering = "mastering";

        // audio capabilities
        pub const mono = "mono";
        pub const stereo = "stereo";
        pub const surround = "surround";
        pub const ambisonic = "ambisonic";
    };

    descriptor: *const Descriptor,
    plugin_data: *anyopaque,
    /// must be called after creating the plugin. if init returns
    /// false the host must destroy the plugin instance. if init
    /// returns true the plugin is initialized and in the deactivated
    /// sate. unlike in `Factory.createPlugin`, in init you have
    /// complete access to the host and host extensions, so clap
    /// related setup activities should be done here rather than
    /// in `Factory.createPlugin`. must be run on main thread
    init: *const fn (plugin: *const Plugin) callconv(.C) bool,
    /// free the plugin and it's resources. it is required to
    /// call `Plugin.deactivate` before this. must be run on
    /// main thread.
    destroy: *const fn (plugin: *const Plugin) callconv(.C) void,
    /// activate the plugin. in this call the plugin may allocate memory
    /// and prepare everything needed for the process call. the process's
    /// sample rate will be constant and process's frame count will be in
    /// the [min, max] range, bounded by [1, `@import("std").math.maxInt(u32)`]
    /// once activated the latency and port configuration must stay consistant
    /// until deactivation. must be called on main thread.
    activate: *const fn (plugin: *const Plugin, sample_rate: f64, min_frames_count: u32, max_frames_count: u32) callconv(.C) bool,
    /// deactivate the plugin. must be called on main thread.
    deactivate: *const fn (plugin: *const Plugin) callconv(.C) void,
    startProcessing: *const fn (plugin: *const Plugin) callconv(.C) bool,
    stopProcessing: *const fn (plugin: *const Plugin) callconv(.C) void,
    reset: *const fn (plugin: *const Plugin) callconv(.C) void,
    process: *const fn (plugin: *const Plugin, process: *const Process) callconv(.C) Process.Status,
    getExtension: *const fn (plugin: *const Plugin, id: [*:0]const u8) callconv(.C) ?*const anyopaque,
    onMainThread: *const fn (plugin: *const Plugin) callconv(.C) void,
};
