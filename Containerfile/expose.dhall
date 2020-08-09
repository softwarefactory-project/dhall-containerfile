let Statement = ./Statement.dhall

let expose
    : Text -> List Statement
    = \(port : Text) -> [ Statement.Expose port ]

in  expose
