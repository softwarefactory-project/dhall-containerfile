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
