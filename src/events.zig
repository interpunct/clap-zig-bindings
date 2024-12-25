const clap = @import("main.zig");
const BeatTime = clap.BeatTime;
const SecTime = clap.SecTime;

pub const SpaceId = enum(u16) { _ };
pub const NoteId = enum(i32) { unspecified = -1, _ };
pub const PortIndex = enum(i16) { unspecified = -1, _ };
pub const Channel = enum(i16) { unspecified = -1, _ };
pub const Key = enum(i16) { unspecified = -1, _ };

pub const core_space_id: SpaceId = @enumFromInt(0);

pub const Header = extern struct {
    pub const Type = enum(u16) {
        /// uses `Note`
        note_on = 0,
        /// uses `Note`
        note_off = 1,
        /// uses `Note`
        note_choke = 2,
        /// uses `Note`
        note_end = 3,
        /// uses `NoteExpression`
        note_expression = 4,
        /// uses `ParamValue`
        param_value = 5,
        /// uses `ParamMod`
        param_mod = 6,
        /// uses `ParamGesture`
        param_gesture_begin = 7,
        /// uses `ParamGesture`
        param_gesture_end = 8,
        /// uses `Transport`
        transport = 9,
        /// uses `Midi`
        midi = 10,
        /// uses `MidiSysex`
        midi_sysex = 11,
        /// uses `Midi2`
        midi2 = 12,
        _,
    };

    pub const Flags = packed struct(u32) {
        /// a live user event, ie a user turning
        /// a knob or playing a key.
        is_live: bool = false,
        /// indicate that the event should not be recorded. ie
        /// parameter is changing due to midi cc, because the
        /// if the host records the automation and the midi cc
        /// there will be a conflict.
        dont_record: bool = false,
        _: u30 = 0,
    };

    /// event size, including the header, eg: `@sizeOf(Note)`
    size: u32,
    /// sample offset within the buffer of this event.
    sample_offset: u32,
    /// event space, see the event_registry extension
    space_id: SpaceId,
    type: Type,
    flags: Flags,
};

pub const Note = extern struct {
    header: Header,
    note_id: NoteId,
    port_index: PortIndex,
    channel: Channel,
    key: Key,
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
    note_id: NoteId,
    port_index: PortIndex,
    channel: Channel,
    key: Key,
    value: f64,
};

pub const ParamValue = extern struct {
    header: Header,
    param_id: clap.Id,
    cookie: ?*anyopaque,
    note_id: NoteId,
    port_index: PortIndex,
    channel: Channel,
    key: Key,
    value: f64,
};

pub const ParamMod = extern struct {
    header: Header,
    param_id: clap.Id,
    cookie: ?*anyopaque,
    note_id: NoteId,
    port_index: PortIndex,
    channel: Channel,
    key: Key,
    value: f64,
};

pub const ParamGesture = extern struct {
    header: Header,
    param_id: clap.Id,
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
    /// the returned event belongs to the list, do not free it!
    get: *const fn (list: *const InputEvents, index: u32) callconv(.C) *const Header,
};

pub const OutputEvents = extern struct {
    context: *anyopaque,
    /// pushes a copy of `event`. returns false if the event could not be pushed.
    tryPush: *const fn (list: *const OutputEvents, event: *const Header) callconv(.C) bool,
};
