{-|
# The dhall-containerfile package

See the README.md for example and usage
-}
{ Type =
    ./Containerfile/Type.dhall sha256:c992973cd017bc040a794a519e14e349dc363420209961d54816dc03d56c444e
, Statement =
    ./Containerfile/Statement.dhall sha256:f5387775947a40035af87900fee991e17b551179bf0e4b1d18cfd1591ea0d8a6
, render =
    ./Containerfile/render.dhall sha256:ef029d6678b7db33a20d37616d04d62cedf8b57388ccfa767dbc26876f402dc4
, optionalStatements =
    ./Containerfile/optionalStatements.dhall sha256:e112cc3399891477b2f6b10ab2b868ad987bdebefcd6534e119f206d50cd8670
, optionalTexts =
    ./Containerfile/optionalTexts.dhall sha256:c136801810a1f3b22dc387bbf61970a952645d9cf16723335ce1c2d615eb6235
, concatSep =
    ./Containerfile/concatSep.dhall sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58
, entrypoint =
    ./Containerfile/entrypoint.dhall sha256:e2b2c3b454d09bf96c56fdf006e0c3eba9cbf18d06878dfab3efb6d2395defdd
, env =
    ./Containerfile/env.dhall sha256:fc3404422b1839493644772ba602cf6a07b2910f075858879a26d6df00f910f4
, from =
    ./Containerfile/from.dhall sha256:d7b51a6939b8d07369f692116491083f841e751580d2b33faa88addad0deb354
, run =
    ./Containerfile/run.dhall sha256:3704ee8de0861581840ff6011df0a1703ed10f524b88fa77298fb569d1eefa20
}
