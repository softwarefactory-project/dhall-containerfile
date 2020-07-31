--| Returns optional list of Statement
let Prelude = ../Prelude.dhall

let Statement = ./Statement.dhall

let optionalStatements
    : Bool -> List Statement -> List Statement
    = \(predicate : Bool) ->
      \(statements : List Statement) ->
        if predicate then statements else Prelude.List.empty Statement

let example0 =
        assert
      :     optionalStatements True [ Statement.Run [ "make" ] ]
        ===  [ Statement.Run [ "make" ] ]

in  optionalStatements
