const clap = @import("main.zig");
const ClapId = clap.ClapId;
const BeatTime = clap.BeatTime;
const SecTime = clap.SecTime;

pub const Event = extern struct {
    pub const Header = extern struct {
        pub const Type = enum(u16) {
            note_on = 0,
            note_off = 1,
            note_choke = 2,
            note_end = 3,
            note_expression = 4,
            param_value = 5,
            param_mod = 6,
            param_gesture_begin = 7,
            param_gesture_end = 8,
            transport = 9,
            midi = 10,
            midi_sysex = 11,
            midi2 = 12,
            _,
        };

        pub const Flags = packed struct(u32) {
            is_live: bool = false,
            dont_record: bool = false,
            _: u30 = 0,
        };

        size: u32,
        sample_offset: u32,
        space_id: u16,
        type: Type,
        flags: Flags,
    };

    pub const core_space_id = 0;

    pub const Note = extern struct {
        header: Header,
        note_id: i32,
        port_index: i16,
        channel: i16,
        key: i16,
        velocity: f64,
    };

    pub const NoteExpression = extern struct {
        pub const Id = enum(i32) {
            volume = 0,
            pan = 1,
            tuning = 2,
            vibrato = 3,
            expression = 4,
            brightness = 5,
            pressure = 6,
        };

        header: Header,
        expression_id: Id,
        note_id: i32,
        port_index: i16,
        channel: i16,
        key: i16,
        value: f64,
    };

    pub const ParamValue = extern struct {
        header: Header,
        param_id: ClapId,
        cookie: *anyopaque,
        note_id: i32,
        port_index: i16,
        channel: i16,
        key: i16,
        value: f64,
    };

    pub const ParamMod = extern struct {
        header: Header,
        param_id: ClapId,
        cookie: *anyopaque,
        note_id: i32,
        port_index: i16,
        channel: i16,
        key: i16,
        value: f64,
    };

    pub const ParamGesture = extern struct {
        header: Header,
        param_id: ClapId,
    };

    pub const Transport = extern struct {
        pub const Flags = packed struct(u32) {
            has_tempo: bool = false,
            has_beats_timeline: bool = false,
            has_seconds_timeline: bool = false,
            has_time_signature: bool = false,
            is_playing: bool = false,
            is_recording: bool = false,
            is_loop_active: bool = false,
            is_within_pre_roll: bool = false,
            _: u24 = 0,
        };

        header: Header,
        flags: Flags,

        song_pos_beats: BeatTime,
        song_pos_seconds: SecTime,

        tempo: f64,
        tempo_increment: f64,

        loop_start_beats: BeatTime,
        loop_end_beats: BeatTime,
        loop_start_seconds: SecTime,
        loop_end_seconds: SecTime,

        bar_start: BeatTime,
        bar_number: i32,

        time_signature_numerator: u16,
        time_signature_denominator: u16,
    };

    pub const Midi = extern struct {
        header: Header,
        port_index: u16,
        data: [3]u8,
    };

    pub const MidiSysex = extern struct {
        header: Header,
        port_index: u16,
        buffer: [*]const u8,
        size: u32,
    };

    pub const Midi2 = extern struct {
        header: Header,
        port_index: u16,
        data: [4]u32,
    };

    pub const InputEvents = extern struct {
        context: *anyopaque,
        size: *const fn (list: *const InputEvents) callconv(.C) u32,
        get: *const fn (list: *const InputEvents, index: u32) callconv(.C) *const Header,
    };

    pub const OutputEvents = extern struct {
        context: *anyopaque,
        try_push: *const fn (list: *const OutputEvents, event: *const Header) callconv(.C) bool,
    };
};
