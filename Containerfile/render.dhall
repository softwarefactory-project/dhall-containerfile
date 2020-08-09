--| Render a Containerfile as Text
let Prelude = ../Prelude.dhall

let Containerfile = { Type = ./Type.dhall }

let Statement = { Type = ./Statement.dhall }

let render
    : Containerfile.Type -> Text
    = \(statements : Containerfile.Type) ->
            Prelude.Text.concatMapSep
              "\n"
              Statement.Type
              ./render/Statement.dhall
              statements
        ++  "\n"

let example0 =
        assert
      :     render
              [ Statement.Type.From "fedora:latest"
              , Statement.Type.Empty
              , Statement.Type.Comment "A comment"
              , Statement.Type.Env (toMap { HOME = "/root", TEST = "a space" })
              , Statement.Type.Empty
              , Statement.Type.Run "dnf install -y emacs && dnf clean --all"
              ]
        ===  ''
             FROM fedora:latest

             # A comment
             ENV HOME="/root" \
                 TEST="a space"

             RUN dnf install -y emacs && dnf clean --all
             ''

in  render
