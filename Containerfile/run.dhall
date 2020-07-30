let Statement = ./Statement.dhall

let run =
      \(comment : Text) ->
      \(commands : List Text) ->
        [ Statement.Comment comment, Statement.Run commands, Statement.Empty ]

in  run
