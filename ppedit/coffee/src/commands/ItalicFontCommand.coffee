#= require Box
#= require ChangeStyleCommand

class ItalicFontCommand extends ChangeStyleCommand

  constructor: (editor, boxesSelector, enable) ->
    styleValue = if enable then 'italic' else 'normal'
    super editor, boxesSelector, {'font-style': styleValue}