--| Render a Containerfile as Text
let Prelude = ../Prelude.dhall

let Containerfile = { Type = ./Type.dhall }

let Statement = { Type = ./Statement.dhall }

let render =
      \(statements : Containerfile.Type) ->
        let renderStatement =
              \(statement : Statement.Type) ->
                merge
                  { From =
                      \(from : Text) ->
                        ''
                        FROM ${from}
                        ''
                  , Comment = \(comment : Text) -> "# ${comment}"
                  , Run = ./renderRun.dhall
                  , Entrypoint =
                      \(entrypoint : List Text) ->
                            "ENTRYPOINT ["
                        ++  Prelude.Text.concatSep
                              ", "
                              (Prelude.List.map Text Text Text/show entrypoint)
                        ++  "]"
                  , Empty = ""
                  }
                  statement

        in      Prelude.Text.concatSep
                  "\n"
                  ( Prelude.List.map
                      Statement.Type
                      Text
                      renderStatement
                      statements
                  )
            ++  "\n"

let example0 =
        assert
      :     render
              [ Statement.Type.From "fedora:latest"
              , Statement.Type.Run [ "dnf install -y emacs", "dnf clean --all" ]
              ]
        ===  ''
             FROM fedora:latest

             RUN dnf install -y emacs && dnf clean --all
             ''

in  render
