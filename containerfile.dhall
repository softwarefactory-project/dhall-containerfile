let concatSep =
      https://prelude.dhall-lang.org/Text/concatSep.dhall sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let map =
      https://prelude.dhall-lang.org/List/map.dhall sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let List/empty =
      https://prelude.dhall-lang.org/List/empty.dhall sha256:b2f561f35098c457353723c93a22bd5de28d26ecc5370814bef9dfda421e0147

let mkRunStatement
    : List Text -> Text
    = \(commands : List Text) -> "RUN " ++ concatSep " && " commands

let ContainerfileStatement =
      < From : Text
      | Comment : Text
      | Run : List Text
      | Entrypoint : List Text
      | Spacer
      >

let renderContainerfileStatment =
      \(statement : ContainerfileStatement) ->
        merge
          { From =
              \(from : Text) ->
                ''
                FROM ${from}
                ''
          , Comment = \(comment : Text) -> "# ${comment}"
          , Run = mkRunStatement
          , Spacer = ""
          , Entrypoint =
              \(entrypoint : List Text) ->
                    ''

                    ENTRYPOINT [''
                ++  concatSep ", " (map Text Text Text/show entrypoint)
                ++  "]"
          }
          statement

let renderContainerfile =
      \(statements : List ContainerfileStatement) ->
            concatSep
              "\n"
              ( map
                  ContainerfileStatement
                  Text
                  renderContainerfileStatment
                  statements
              )
        ++  "\n"

let example0 =
        assert
      :     renderContainerfile
              [ ContainerfileStatement.From "fedora:latest"
              , ContainerfileStatement.Run
                  [ "dnf install -y emacs", "dnf clean --all" ]
              ]
        ===  ''
             FROM fedora:latest

             RUN dnf install -y emacs && dnf clean --all
             ''

in  { render = renderContainerfile
    , Type = ContainerfileStatement
    , empty = List/empty ContainerfileStatement
    }
