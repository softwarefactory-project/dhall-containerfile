--| A convenient function to create entrypoint
let Statement = ./Statement.dhall

let entrypoint
    : List Text -> List Statement
    = \(entrypoint : List Text) -> [ Statement.Entrypoint entrypoint ]

let example0 =
        assert
      : entrypoint [ "/bin/bash" ] === [ Statement.Entrypoint [ "/bin/bash" ] ]

in  entrypoint
