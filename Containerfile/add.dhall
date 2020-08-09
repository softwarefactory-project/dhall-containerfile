--| A convenient function to create from
let Statement = ./Statement.dhall

let add
    : List Text -> List Statement
    = \(files : List Text) -> [ Statement.Add files ]

in  add
