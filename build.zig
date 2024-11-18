const std = @import("std");

pub fn build(b: *std.Build) void {
    // this allows other code that depends on this
    // one to not have to re-declare the module.
    const clap_bindings_module = b.addModule(
        "clap-bindings",
        .{ .root_source_file = b.path("src/main.zig") },
    );
    _ = clap_bindings_module;

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);

    b.default_step.dependOn(test_step);
}
