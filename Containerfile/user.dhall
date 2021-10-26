let Prelude = ../Prelude.dhall

let Statement = ./Statement.dhall

let user
    : Text -> List Statement
    = \(user : Text) -> [ Statement.User user ]

in  user
