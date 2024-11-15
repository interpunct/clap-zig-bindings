pub const Version = extern struct {
    major: u32,
    minor: u32,
    revision: u32,

    pub fn isCompatible(version: Version) bool {
        // versions 0.x.y were used during development stage and are not compatible
        return version.major >= 1;
    }
};
