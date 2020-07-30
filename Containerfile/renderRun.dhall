--| Render a Statement.Run as Text
let Prelude = ../Prelude.dhall

let renderRun
    : List Text -> Text
    = \(commands : List Text) ->
        "RUN " ++ Prelude.Text.concatSep " && " commands

let example0 =
        assert
      :     renderRun [ "dnf install -y emacs", "dnf clean --all" ]
        ===  "RUN dnf install -y emacs && dnf clean --all"

in  renderRun
