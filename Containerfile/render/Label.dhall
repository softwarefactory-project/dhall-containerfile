let renderLabel = ./prefixMapText.dhall "LABEL"

let example0 =
        assert
      :         renderLabel (toMap { Version = "1.0", description = "Test" })
            ++  "\n"
        ===  ''
             LABEL Version="1.0"
             LABEL description="Test"
             ''

in  renderLabel
