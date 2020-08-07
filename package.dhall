{-|
# The dhall-containerfile package

See the README.md for example and usage
-}
{ Type =
    ./Containerfile/Type.dhall sha256:f6310f0850d9efa00720aa8f07ecfb9fc23493959d0e8b59c4c499a4da9b93a5
, Statement =
    ./Containerfile/Statement.dhall sha256:e6beca645207a9d609cc717d43698202824b53414bf30cb2b32df3999269d7c4
, render =
    ./Containerfile/render.dhall sha256:fcdc28b0c801ff732a1e4a454ab48bd262a786f38c3b06b6af9ec811aef76423
, optionalStatements =
    ./Containerfile/optionalStatements.dhall sha256:3a57b6ad6b3c3b696886ea2f5307ba230b42a0617186c15ac95043caa24127b6
, optionalTexts =
    ./Containerfile/optionalTexts.dhall sha256:c136801810a1f3b22dc387bbf61970a952645d9cf16723335ce1c2d615eb6235
, concatSep =
    ./Containerfile/concatSep.dhall sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58
, entrypoint =
    ./Containerfile/entrypoint.dhall sha256:7050ba097b84592de88dde1b1a798fd64fe7a5181441bcdbb0e7504589c3242b
, env =
    ./Containerfile/env.dhall sha256:c03f5d2e8045988aac6fc7e060d825b77d35b68f2305baa2f5b5f1259c1d1e20
, from =
    ./Containerfile/from.dhall sha256:e6eb00242d133cd10310b44b18fb4771ff93e10396f4f53c967300e11dd978ab
, run =
    ./Containerfile/run.dhall sha256:7c2d1149b67f5dc90d602ba43b3426987944607ac3bc9ddc4aa86d53b90de994
}
