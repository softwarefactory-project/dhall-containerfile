let Statement = ./Statement.dhall

let run
    : Text -> List Text -> List Statement
    = \(comment : Text) ->
      \(commands : List Text) ->
        [ Statement.Comment comment, Statement.Run commands, Statement.Empty ]

in  run
