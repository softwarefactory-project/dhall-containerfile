let Prelude = ../../Prelude.dhall

let Statement = { Type = ../Statement.dhall }

let prefixText = \(prefix : Text) -> \(text : Text) -> "${prefix} ${text}"

let prefixTextList =
      \(prefix : Text) ->
      \(list : List Text) ->
        "${prefix} " ++ ./textList.dhall list

let renderStatement =
      \(statement : Statement.Type) ->
        merge
          { From = prefixText "FROM"
          , Comment = prefixText "#"
          , Workdir = prefixText "WORKDIR"
          , Run = prefixText "RUN"
          , Cmd = prefixTextList "CMD"
          , Exec = prefixTextList "RUN"
          , Expose = prefixText "EXPOSE"
          , Add = prefixTextList "ADD"
          , Copy = prefixTextList "COPY"
          , Entrypoint = prefixTextList "ENTRYPOINT"
          , Env = ./Env.dhall
          , Label = ./Label.dhall
          , Empty = ""
          }
          statement

in  renderStatement
