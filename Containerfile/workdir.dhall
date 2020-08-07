--| A convenient function to create workdir
let Statement = ./Statement.dhall

let workdir
    : Text -> List Statement
    = \(workdir : Text) -> [ Statement.Workdir workdir ]

let example0 = assert : workdir "/tmp" === [ Statement.Workdir "/tmp" ]

in  workdir
