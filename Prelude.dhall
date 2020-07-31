{-|
This file provides a central `Prelude` import for the rest of the library to
use so that the integrity check only needs to be updated in one place
whenever upgrading the interpreter.
-}
  env:DHALL_PRELUDE
? https://prelude.dhall-lang.org/v17.0.0/package.dhall sha256:10db3c919c25e9046833df897a8ffe2701dc390fa0893d958c3430524be5a43e
