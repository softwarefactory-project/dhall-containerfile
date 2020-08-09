let Prelude = ../Prelude.dhall

let Statement = ./Statement.dhall

let arg
    : Prelude.Map.Type Text Text -> List Statement
    = \(args : Prelude.Map.Type Text Text) -> [ Statement.Arg args ]

in  arg
