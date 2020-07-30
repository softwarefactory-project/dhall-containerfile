let Containerfile =
      https://softwarefactory-project.io/cgit/software-factory/dhall-containerfile/plain/package.dhall sha256:c354a19170e2354b1f4dc3bd2447d30e6e45147e1f2f0eff53ad2beaae6b69fa

let concatSep =
      https://prelude.dhall-lang.org/Text/concatSep.dhall sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let List/empty =
      https://prelude.dhall-lang.org/List/empty.dhall sha256:b2f561f35098c457353723c93a22bd5de28d26ecc5370814bef9dfda421e0147

let FfmpegOption =
      { Type = { x264 : Bool, xcb : Bool }
      , default = { x264 = True, xcb = True }
      }

let buildLib =
      \(name : Text) ->
      \(url : Text) ->
      \(build-commands : List Text) ->
          [ Containerfile.Type.Comment
              "${name}: ${concatSep " " build-commands}"
          , Containerfile.Type.Run
              (   [ "cd /usr/local/src"
                  , "git clone --depth 1 ${url}"
                  , "cd ${name}"
                  ]
                # build-commands
                # [ "make", "make install" ]
              )
          , Containerfile.Type.Spacer
          ]
        : List Containerfile.Type

let simpleBlock =
      \(comment : Text) ->
      \(commands : List Text) ->
        [ Containerfile.Type.Comment comment
        , Containerfile.Type.Run commands
        , Containerfile.Type.Spacer
        ]

let mkContainerfile
    : FfmpegOption.Type -> List Containerfile.Type
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
              # (if options.xcb then [ "libxcb-devel" ] else List/empty Text)

        let runtime-reqs =
                [ "numactl" ]
              # (if options.xcb then [ "libxcb" ] else List/empty Text)

        let x264-build =
              if    options.x264
              then  buildLib
                      "x264"
                      "https://code.videolan.org/videolan/x264.git"
                      [ "./configure --prefix=\"/usr/local\" --enable-static" ]
              else  Containerfile.empty

        let yasm-build =
              buildLib
                "yasm"
                "git://github.com/yasm/yasm.git"
                [ "autoreconf -fiv", "./configure --prefix=\"/usr/local\"" ]

        let ffmpeg-build =
              buildLib
                "ffmpeg"
                "git://source.ffmpeg.org/ffmpeg"
                [ concatSep
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
                      # ( if    options.x264
                          then  [ "--enable-libx264" ]
                          else  List/empty Text
                        )
                      # ( if    options.xcb
                          then  [ "--enable-libxcb" ]
                          else  List/empty Text
                        )
                    )
                ]

        let bootstrap =
              simpleBlock
                "Install build and runtime reqs"
                [ "dnf install -y " ++ concatSep " " (build-reqs # runtime-reqs)
                ]

        let cleanup =
              simpleBlock
                "Cleanup"
                [ "rm -Rf /usr/local/src/*"
                , "dnf clean all"
                , "dnf erase -y " ++ concatSep " " build-reqs
                ]

        let from = [ Containerfile.Type.From "fedora:latest" ]

        let entrypoint =
              [ Containerfile.Type.Entrypoint [ "/usr/local/bin/ffmpeg" ] ]

        in    from
            # bootstrap
            # yasm-build
            # x264-build
            # ffmpeg-build
            # cleanup
            # entrypoint

in  { Containerfile =
        Containerfile.render (mkContainerfile FfmpegOption.default)
    , make = mkContainerfile
    , buildLib
    }
