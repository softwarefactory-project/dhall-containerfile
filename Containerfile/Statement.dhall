{-|
Based on [Dockerfile format](https://docs.docker.com/engine/reference/builder/#format)
-}
  < From : Text
  | Comment : Text
  | Run : List Text
  | Entrypoint : List Text
  | Empty
  >
: Type
