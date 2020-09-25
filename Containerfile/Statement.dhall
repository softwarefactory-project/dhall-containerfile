{-|
Based on [Dockerfile format](https://docs.docker.com/engine/reference/builder/#format)
-}
let Prelude = ../Prelude.dhall

in    < From : Text
      | Run : Text
      | Cmd : List Text
      | Exec : List Text
      | Label : Prelude.Map.Type Text Text
      | Expose : Text
      | Env : Prelude.Map.Type Text Text
      | Add : List Text
      | Copy : List Text
      | CopyFrom : { from : Text, files : List Text }
      | Entrypoint : List Text
      | Volume : List Text
      | User : Text
      | Workdir : Text
      | Arg : Prelude.Map.Type Text Text
      | Shell : List Text
      | Comment : Text
      | Empty
      >
    : Type
