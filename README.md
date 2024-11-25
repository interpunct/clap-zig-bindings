# [clap-zig-bindings]

Zig bindings for the [CLAP] audio API. Currently covers 100% of the api as of
CLAP version `1.2.2`. This library does not cover draft extensions.

This is a full hand-written translation. Everything is done to make the most of
Zig's type system.

For an example on how to use this library, see the [clap-bindings-example] git
repo.

This is not a plugin framework!

## including as a dependency

use the `zig fetch` command, ie:

```sh
zig fetch --save git+https://git.sr.ht/~interpunct/clap-zig-bindings
```

Then add the following to your `build.zig`:

```zig
const clap_bindings = b.dependency("clap-bindings", .{})
exe.root_module.addImport("clap-bindings", clap_bindings.module("clap-bindings"));
```

This library currently targets Zig version `0.13.0`.

## issue tracker

Browse tickets at <https://todo.sr.ht/~interpunct/clap-zig-bindings>.

If you are having issues and there is not already an open ticket for them at the
page above please send an email with what your problems are to [my public inbox],
and I will make a ticket for them. This does not require a sourcehut account.

## contributing

Patches are done by email on [my public inbox]. This is funcitonality built in
to git. If this workflow is new to you please refer to the [sourcehut docs]. I
promise that it is quick and easy to both learn and set up.

## license

`clap-zig-bindings` is distributed under LGPLv3, see the LICENSE file.

[clap-zig-bindings]: https://sr.ht/~interpunct/clap-zig-bindings/
[clap-bindings-example]: https://git.sr.ht/~interpunct/clap-bindings-example
[CLAP]: https://cleveraudio.org
[my public inbox]: https://lists.sr.ht/~interpunct/public-inbox
[sourcehut docs]: https://man.sr.ht/git.sr.ht/send-email.md

