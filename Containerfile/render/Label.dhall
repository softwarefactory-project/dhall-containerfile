let Prelude = ../../Prelude.dhall

let Entry = { mapKey : Text, mapValue : Text }

let Map = List Entry

let renderLabel
    : Map -> Text
    = Prelude.Text.concatMapSep
        "\n"
        Entry
        (\(entry : Entry) -> "LABEL " ++ ./textEntry.dhall entry)

let example0 =
        assert
      :         renderLabel (toMap { Version = "1.0", description = "Test" })
            ++  "\n"
        ===  ''
             LABEL Version="1.0"
             LABEL description="Test"
             ''

in  renderLabel
