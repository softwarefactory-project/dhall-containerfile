let Prelude = ../../Prelude.dhall

let renderTextList
    : List Text -> Text
    = \(args : List Text) ->
            "["
        ++  Prelude.Text.concatSep
              ", "
              (Prelude.List.map Text Text Text/show args)
        ++  "]"

let example0 =
        assert
      :     renderTextList [ "echo", "hello world" ]
        ===  "[\"echo\", \"hello world\"]"

in  renderTextList
