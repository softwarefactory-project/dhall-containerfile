--| A convenient function to create volume
let Statement = ./Statement.dhall

let volume
    : List Text -> List Statement
    = \(volumes : List Text) -> [ Statement.Volume volumes ]

in  volume
