let Prelude = ../../Prelude.dhall

let Entry = { mapKey : Text, mapValue : Text }

let Map = List Entry

let renderPrefixMapText
    : Text -> Map -> Text
    = \(prefix : Text) ->
        Prelude.Text.concatMapSep
          "\n"
          Entry
          (\(entry : Entry) -> "${prefix} " ++ ./textEntry.dhall entry)

in  renderPrefixMapText
