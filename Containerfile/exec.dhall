--| The RUN `exec` form
let Prelude = ../Prelude.dhall

let Statement = ./Statement.dhall

let exec
    : Text -> List Text -> List Statement
    = \(comment : Text) ->
      \(args : List Text) ->
        [ Statement.Comment comment, Statement.Exec args, Statement.Empty ]

let example0 =
        assert
      :     exec "Install emacs" [ "dnf install -y emacs", "dnf clean all" ]
        ===  [ Statement.Comment "Install emacs"
             , Statement.Exec [ "dnf install -y emacs", "dnf clean all" ]
             , Statement.Empty
             ]

in  exec
