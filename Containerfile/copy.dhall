--| A convenient function to create copy
let Statement = ./Statement.dhall

let copy
    : List Text -> List Statement
    = \(files : List Text) -> [ Statement.Copy files ]

in  copy
