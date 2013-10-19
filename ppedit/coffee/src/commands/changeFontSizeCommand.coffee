#= require Box
#= require ChangeStyleCommand

class ChangeFontSizeCommand extends ChangeStyleCommand

  constructor: (editor, boxesSelector, newFontSize) ->
    super editor, boxesSelector, {'font-size': newFontSize}