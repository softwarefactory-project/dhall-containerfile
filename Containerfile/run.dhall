let Statement = ./Statement.dhall

let run
    : Text -> List Text -> List Statement
    = \(comment : Text) ->
      \(commands : List Text) ->
        [ Statement.Comment comment, Statement.Run commands, Statement.Empty ]

let example0 =
        assert
      :     run "Install emacs" [ "dnf install -y emacs", "dnf clean all" ]
        ===  [ Statement.Comment "Install emacs"
             , Statement.Run [ "dnf install -y emacs", "dnf clean all" ]
             , Statement.Empty
             ]

in  run
