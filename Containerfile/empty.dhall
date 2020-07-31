--| A convenient empty statement list
let Prelude = ../Prelude.dhall

let Statement = ./Statement.dhall

in  Prelude.List.empty ./Statement.dhall : List Statement
