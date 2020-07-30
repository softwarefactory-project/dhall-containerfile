{-|
# The dhall-containerfile package

See the README.md for example and usage
-}
{ Type =
    ./Containerfile/Type.dhall sha256:bad26cc556029b1f1c06259b7ddce596ae867d3fe13af11360cbd6d6e4a916fb
, Statement =
    ./Containerfile/Statement.dhall sha256:3e882c49815238e6fc8e21d299cf7fa54fe4c6aa4603a19e2a92fe15ba249c57
, render =
    ./Containerfile/render.dhall sha256:87974812398b472ff9f1943a4814ac5d9ddf279819c8e160bfee95d01cdcbcc1
, empty =
    ./Containerfile/empty.dhall sha256:675bf7fabdb3742c2d679c9770ef7fdea08d7b01b6d6eca5c34f89d56ec3a027
, concatSep =
    ./Containerfile/concatSep.dhall sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58
, run =
    ./Containerfile/run.dhall sha256:6653469fdd6b8f17cb8255f2f9a556af657d6c7f6657c234609a788ff39c496a
}
