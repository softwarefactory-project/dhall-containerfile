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
      | Empty
      >
    : Type
