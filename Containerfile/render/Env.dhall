let Prelude = ../../Prelude.dhall

let renderEnvEntry
    : Prelude.Map.Entry Text Text -> Text
    = \(entry : Prelude.Map.Entry Text Text) ->
        "ENV ${entry.mapKey} ${entry.mapValue}"

let renderEnv
    : Prelude.Map.Type Text Text -> Text
    = \(map : Prelude.Map.Type Text Text) ->
        Prelude.Text.concatSep
          "\n"
          ( Prelude.List.map
              (Prelude.Map.Entry Text Text)
              Text
              renderEnvEntry
              map
          )

let example0 =
        assert
      :         renderEnv
                  ( toMap
                      { HOME = "/root"
                      , TEST = "a space"
                      , PATH = "/usr/bin:\$PATH"
                      }
                  )
            ++  "\n"
        ===  ''
             ENV HOME /root
             ENV PATH /usr/bin:$PATH
             ENV TEST a space
             ''

in  renderEnv
