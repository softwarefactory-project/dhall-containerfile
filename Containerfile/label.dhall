let Prelude = ../Prelude.dhall

let Statement = ./Statement.dhall

let label
    : Prelude.Map.Type Text Text -> List Statement
    = \(label : Prelude.Map.Type Text Text) -> [ Statement.Label label ]

in  label
