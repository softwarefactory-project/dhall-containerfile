--| Returns optional list of Text
let Prelude = ../Prelude.dhall

let optionalTexts
    : Bool -> List Text -> List Text
    = \(predicate : Bool) ->
      \(texts : List Text) ->
        if predicate then texts else Prelude.List.empty Text

let example0 =
      assert : optionalTexts True [ "emacs", "vim" ] === [ "emacs", "vim" ]

let example1 =
        assert
      : optionalTexts False [ "emacs", "vim" ] === Prelude.List.empty Text

in  optionalTexts
