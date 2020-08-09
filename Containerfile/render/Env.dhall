let Prelude = ../../Prelude.dhall

let Entry = { mapKey : Text, mapValue : Text }

let Map = List Entry

let renderTextEntry
    : Entry -> Text
    = \(entry : Entry) -> "${entry.mapKey}=${Text/show entry.mapValue}"

let renderTextMap
    : Map -> Text
    = \(map : Map) ->
        Prelude.Text.concatSep
          ''
           \
          ${"    "}''
          (Prelude.List.map Entry Text renderTextEntry map)

let renderEnv
    : Map -> Text
    = \(map : Map) -> "ENV " ++ renderTextMap map

let example0 =
        assert
      :     renderEnv (toMap { HOME = "/root", TEST = "a space" }) ++ "\n"
        ===  ''
             ENV HOME="/root" \
                 TEST="a space"
             ''

in  renderEnv
