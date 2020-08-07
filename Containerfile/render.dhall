--| Render a Containerfile as Text
let Prelude = ../Prelude.dhall

let Containerfile = { Type = ./Type.dhall }

let Statement = { Type = ./Statement.dhall }

let render
    : Containerfile.Type -> Text
    = \(statements : Containerfile.Type) ->
        let renderEnv =
              \(env : Prelude.Map.Type Text Text) ->
                let EnvEntry = Prelude.Map.Entry Text Text

                let envText =
                      Prelude.Text.concatSep
                        ''

                        ${"    "}''
                        ( Prelude.List.map
                            EnvEntry
                            Text
                            ( \(env : EnvEntry) ->
                                "${env.mapKey}=${env.mapValue}"
                            )
                            env
                        )

                in  "ENV " ++ envText

        let renderStatement =
              \(statement : Statement.Type) ->
                merge
                  { From =
                      \(from : Text) ->
                        ''
                        FROM ${from}
                        ''
                  , Env = renderEnv
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
              , Statement.Type.Env
                  (toMap { HOME = "/root", PATH = "/root/.cabal/bin" })
              , Statement.Type.Run [ "dnf install -y emacs", "dnf clean --all" ]
              ]
        ===  ''
             FROM fedora:latest

             ENV HOME=/root
                 PATH=/root/.cabal/bin
             RUN dnf install -y emacs && dnf clean --all
             ''

in  render
