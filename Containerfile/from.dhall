--| A convenient function to create from
let Statement = ./Statement.dhall

let from
    : Text -> List Statement
    = \(from : Text) -> [ Statement.From from ]

let example0 = from "fedora" === [ Statement.From "fedora" ]

in  from
