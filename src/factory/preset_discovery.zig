const clap = @import("../main.zig");

pub const Flags = packed struct(u32) {
    factory_content: bool = false,
    user_content: bool = false,
    demo_content: bool = false,
    favorite: bool = false,
    _: u28 = 0,
};

pub const MetadataReceiver = extern struct {
    receiver_data: *anyopaque,

    onError: *const fn (
        receiver: *const MetadataReceiver,
        os_error: i32,
        error_message: [*:0]const u8,
    ) callconv(.C) void,
    beginPreset: *const fn (
        receiver: *const MetadataReceiver,
        name: ?[*:0]const u8,
        load_key: ?[*:0]const u8,
    ) callconv(.C) bool,
    addPluginId: *const fn (
        receiver: *const MetadataReceiver,
        plugin_id: *const clap.UniversalPluginId,
    ) callconv(.C) void,
    setSoundpackId: *const fn (
        receiver: *const MetadataReceiver,
        soundpack_id: [*:0]const u8,
    ) callconv(.C) void,
    setFlags: *const fn (
        receiver: *const MetadataReceiver,
        flags: Flags,
    ) callconv(.C) void,
    addCreator: *const fn (
        receiver: *const MetadataReceiver,
        creator: [*:0]const u8,
    ) callconv(.C) void,
    setDescription: *const fn (
        receiver: *const MetadataReceiver,
        description: [*:0]const u8,
    ) callconv(.C) void,
    setTimestamps: *const fn (
        receiver: *const MetadataReceiver,
        creation_time: clap.Timestamp,
        modification_time: clap.Timestamp,
    ) callconv(.C) void,
    addFeature: *const fn (
        receiver: *const MetadataReceiver,
        feature: [*:0]const u8,
    ) callconv(.C) void,
    addExtraInfo: *const fn (
        receiver: *const MetadataReceiver,
        key: [*:0]const u8,
        value: [*:0]const u8,
    ) callconv(.C) void,
};

pub const Filetype = extern struct {
    name: [*:0]const u8,
    description: ?[*:0]const u8,
    file_extension: ?[*:0]const u8,
};

pub const Location = extern struct {
    pub const Kind = enum(u32) { file = 0, plugin = 1 };

    flags: Flags,
    name: [*:0]const u8,
    kind: Kind,
    location: ?[*:0]const u8,
};

pub const Soundpack = extern struct {
    flags: Flags,
    id: [*:0]const u8,
    name: [*:0]const u8,
    description: ?[*:0]const u8,
    homepage_url: ?[*:0]const u8,
    vendor: ?[*:0]const u8,
    image_path: ?[*:0]const u8,
    release_timestamp: clap.Timestamp,
};

pub const Provider = extern struct {
    pub const Descriptor = extern struct {
        clap_version: clap.Version,
        id: [*:0]const u8,
        name: [*:0]const u8,
        vendor: ?[*:0]const u8,
    };

    descriptor: *const Descriptor,
    provider_data: *anyopaque,

    init: *const fn (provider: *const Provider) callconv(.C) bool,
    destroy: *const fn (provider: *const Provider) callconv(.C) void,
    getMetadata: *const fn (
        provider: *const Provider,
        location_kind: Location.Kind,
        location: [*:0]const u8,
        metadata_receiver: *const MetadataReceiver,
    ) callconv(.C) bool,
    getExtension: *const fn (
        provider: *const Provider,
        extension_id: [*:0]const u8,
    ) callconv(.C) ?*const anyopaque,
};

pub const Indexer = extern struct {
    clap_version: clap.Version,
    name: [*:0]const u8,
    vendor: ?[*:0]const u8,
    url: ?[*:0]const u8,
    version: ?[*:0]const u8,
    indexer_data: *anyopaque,

    declareFiletype: *const fn (indexer: *const Indexer, filetype: *const Filetype) callconv(.C) bool,
    declareLocation: *const fn (indexer: *const Indexer, location: *const Location) callconv(.C) bool,
    declareSoundpack: *const fn (indexer: *const Indexer, soundpack: *const Soundpack) callconv(.C) bool,
    getExtension: *const fn (indexer: *const Indexer, extension_id: [*:0]const u8) callconv(.C) ?*anyopaque,
};

pub const Factory = extern struct {
    pub const id = "clap.preset-discovery-factory/2";

    count: *const fn (factory: *const Factory) callconv(.C) u32,
    getDescriptor: *const fn (factory: *const Factory, index: u32) callconv(.C) ?*const Provider.Descriptor,
    create: *const fn (
        factory: *const Factory,
        indexer: *const Indexer,
        provider_id: [*:0]const u8,
    ) callconv(.C) ?*Provider,
};
