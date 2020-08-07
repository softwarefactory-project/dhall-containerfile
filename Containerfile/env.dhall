let Prelude = ../Prelude.dhall

let Statement = ./Statement.dhall

let env
    : Prelude.Map.Type Text Text -> List Statement
    = \(env : Prelude.Map.Type Text Text) -> [ Statement.Env env ]

let example0 =
        assert
      :     env (toMap { HOME = "/root" })
        ===  [ Statement.Env (toMap { HOME = "/root" }) ]

in  env
