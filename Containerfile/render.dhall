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
                         \
                        ${"    "}''
                        ( Prelude.List.map
                            EnvEntry
                            Text
                            ( \(env : EnvEntry) ->
                                "${env.mapKey}=${Text/show env.mapValue}"
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
                  , Workdir = \(workdir : Text) -> "WORKDIR ${workdir}"
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
              , Statement.Type.Comment "A comment"
              , Statement.Type.Env (toMap { HOME = "/root", TEST = "a space" })
              , Statement.Type.Empty
              , Statement.Type.Run [ "dnf install -y emacs", "dnf clean --all" ]
              ]
        ===  ''
             FROM fedora:latest

             # A comment
             ENV HOME="/root" \
                 TEST="a space"

             RUN dnf install -y emacs && dnf clean --all
             ''

in  render
