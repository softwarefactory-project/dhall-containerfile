{-|
Based on [Dockerfile format](https://docs.docker.com/engine/reference/builder/#format)
-}
let Prelude = ../Prelude.dhall

in    < From : Text
      | Env : Prelude.Map.Type Text Text
      | Comment : Text
      | Run : List Text
      | Entrypoint : List Text
      | Empty
      >
    : Type