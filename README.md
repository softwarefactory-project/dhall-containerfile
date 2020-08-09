# dhall-containerfile

Manage your Containerfile with [Dhall][dhall-lang].

Main [documentation](https://docs.softwarefactory-project.io/dhall-containerfile/)

## Usage

The package provides convenient function to create the statements:

```dhall
-- ./examples/demo.dhall
let Containerfile = ../package.dhall

in    Containerfile.from "fedora"
    # Containerfile.emptyLine
    # Containerfile.run
        "Install emacs"
        [ "dnf update -y", "dnf install -y emacs-nox", "dnf clean all" ]
    # Containerfile.label
        ( toMap
            { description = "a text editor"
            , maintainer = "tdecacqu@redhat.com"
            }
        )
    # Containerfile.emptyLine
    # Containerfile.entrypoint [ "emacs" ]

```

```
# dhall text <<< '(./package.dhall).render ./examples/demo.dhall'
FROM fedora

# Install emacs
RUN dnf update -y && dnf install -y emacs-nox && dnf clean all

LABEL description="a text editor"
LABEL maintainer="tdecacqu@redhat.com"

ENTRYPOINT ["emacs"]

```

## Reference

The package implements the [Containerfile reference][ref] with these changes:

* `Exec` is the `RUN` exec form
* `Cmd` only supports the preferred exec form
* `Empty` denotes an empty lines
* `Add` only supports the list form without chown argument
* `Copy` only supports the list form without chown argument
* `Entrypoint` only supports the prefered exec form

```dhall
-- ./Containerfile/Statement.dhall
{-|
Based on [Dockerfile format](https://docs.docker.com/engine/reference/builder/#format)
-}
let Prelude = ../Prelude.dhall

in    < From : Text
      | Env : Prelude.Map.Type Text Text
      | Label : Prelude.Map.Type Text Text
      | Comment : Text
      | Run : Text
      | Cmd : List Text
      | Exec : List Text
      | Expose : Text
      | Workdir : Text
      | Entrypoint : List Text
      | Add : List Text
      | Copy : List Text
      | Empty
      >
    : Type

```

## Example

A complete example to build an ffmpeg image with some options:

```dhall
-- ./examples/ffmpeg.dhall
let Containerfile = ../package.dhall

let FfmpegOption =
      { Type = { x264 : Bool, xcb : Bool }
      , default = { x264 = True, xcb = True }
      }

let buildLib =
      \(name : Text) ->
      \(url : Text) ->
      \(build-commands : List Text) ->
        Containerfile.run
          "${name}: ${Containerfile.concatSep " " build-commands}"
          (   [ "cd /usr/local/src"
              , "git clone --depth 1 ${url}"
              , "cd ${name}"
              ]
            # build-commands
            # [ "make", "make install" ]
          )

let make
    : FfmpegOption.Type -> Containerfile.Type
    = \(options : FfmpegOption.Type) ->
        let build-reqs =
                [ "autoconf"
                , "automake"
                , "cmake"
                , "freetype-devel"
                , "gcc"
                , "gcc-c++"
                , "git"
                , "libtool"
                , "make"
                , "nasm"
                , "pkgconfig"
                , "zlib-devel"
                , "numactl-devel"
                ]
              # Containerfile.optionalTexts options.xcb [ "libxcb-devel" ]

        let runtime-reqs =
                [ "numactl" ]
              # Containerfile.optionalTexts options.xcb [ "libxcb" ]

        let x264-build =
              Containerfile.optionalStatements
                options.x264
                ( buildLib
                    "x264"
                    "https://code.videolan.org/videolan/x264.git"
                    [ "./configure --prefix=\"/usr/local\" --enable-static" ]
                )

        let yasm-build =
              buildLib
                "yasm"
                "git://github.com/yasm/yasm.git"
                [ "autoreconf -fiv", "./configure --prefix=\"/usr/local\"" ]

        let ffmpeg-build =
              buildLib
                "ffmpeg"
                "git://source.ffmpeg.org/ffmpeg"
                [ Containerfile.concatSep
                    " "
                    (   [ "PKG_CONFIG_PATH=\"/usr/local/lib/pkgconfig\""
                        , "./configure"
                        , "--prefix=\"/usr/local\""
                        , "--extra-cflags=\"-I/usr/local/include\""
                        , "--extra-ldflags=\"-L/usr/local/lib\""
                        , "--pkg-config-flags=\"--static\""
                        , "--enable-gpl"
                        , "--enable-nonfree"
                        ]
                      # Containerfile.optionalTexts
                          options.x264
                          [ "--enable-libx264" ]
                      # Containerfile.optionalTexts
                          options.xcb
                          [ "--enable-libxcb" ]
                    )
                ]

        let bootstrap =
              Containerfile.run
                "Install build and runtime reqs"
                [     "dnf install -y "
                  ++  Containerfile.concatSep " " (build-reqs # runtime-reqs)
                ]

        let cleanup =
              Containerfile.run
                "Cleanup"
                [ "rm -Rf /usr/local/src/*"
                , "dnf clean all"
                , "dnf erase -y " ++ Containerfile.concatSep " " build-reqs
                ]

        in    Containerfile.from "fedora:latest"
            # Containerfile.emptyLine
            # bootstrap
            # yasm-build
            # x264-build
            # ffmpeg-build
            # cleanup
            # Containerfile.entrypoint [ "/usr/local/bin/ffmpeg" ]

in  { Containerfile = Containerfile.render (make FfmpegOption.default)
    , make
    , buildLib
    }

```

```text
# dhall text <<< '(./examples/ffmpeg.dhall).Containerfile'
FROM fedora:latest

# Install build and runtime reqs
RUN dnf install -y autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make nasm pkgconfig zlib-devel numactl-devel libxcb-devel numactl libxcb

# yasm: autoreconf -fiv ./configure --prefix="/usr/local"
RUN cd /usr/local/src && git clone --depth 1 git://github.com/yasm/yasm.git && cd yasm && autoreconf -fiv && ./configure --prefix="/usr/local" && make && make install

# x264: ./configure --prefix="/usr/local" --enable-static
RUN cd /usr/local/src && git clone --depth 1 https://code.videolan.org/videolan/x264.git && cd x264 && ./configure --prefix="/usr/local" --enable-static && make && make install

# ffmpeg: PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" ./configure --prefix="/usr/local" --extra-cflags="-I/usr/local/include" --extra-ldflags="-L/usr/local/lib" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libx264 --enable-libxcb
RUN cd /usr/local/src && git clone --depth 1 git://source.ffmpeg.org/ffmpeg && cd ffmpeg && PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" ./configure --prefix="/usr/local" --extra-cflags="-I/usr/local/include" --extra-ldflags="-L/usr/local/lib" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libx264 --enable-libxcb && make && make install

# Cleanup
RUN rm -Rf /usr/local/src/* && dnf clean all && dnf erase -y autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make nasm pkgconfig zlib-devel numactl-devel libxcb-devel

ENTRYPOINT ["/usr/local/bin/ffmpeg"]

```

[dhall-lang]: https://dhall-lang.org
[ref]: https://docs.docker.com/engine/reference/builder/
