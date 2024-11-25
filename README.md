# [clap-zig-bindings]

Zig bindings for the [CLAP] audio API. This is a full hand-written translation.
Everything is done to make the most of Zig's type system. Currently covers
100% of the api as of CLAP version `1.2.2`. This library does not cover draft
extensions.

For an example on how to use this library, see the [clap-bindings-example] git
repo.

This is not a plugin framework!

## including as a dependency

Use the `zig fetch` command, ie:

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

If you have issues and there is no open ticket for them at the page above please
send an email with your problems to [my public inbox]. I will look into and make
any needed tickets for them. This does not require a sourcehut account.

## contributing

Patches and disscussion are are done via email on [my public inbox]. This is
funcitonality built in to git. If this workflow is new to you please refer to
<https://git-send-email.io>. I promise that it is quick and easy to both learn
and set up.

## license

`clap-zig-bindings` is distributed under LGPLv3, see the LICENSE file.

[clap-zig-bindings]: https://sr.ht/~interpunct/clap-zig-bindings/
[clap-bindings-example]: https://git.sr.ht/~interpunct/clap-bindings-example
[CLAP]: https://cleveraudio.org
[my public inbox]: https://lists.sr.ht/~interpunct/public-inbox
