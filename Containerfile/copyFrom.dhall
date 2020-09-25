let Statement = ./Statement.dhall

let copyFrom =
      \(from : Text) ->
      \(files : List Text) ->
        [ Statement.CopyFrom { from, files } ]

in  copyFrom
