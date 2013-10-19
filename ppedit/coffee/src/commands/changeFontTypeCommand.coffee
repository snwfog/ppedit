#= require Box
#= require ChangeStyleCommand

class ChangeFontTypeCommand extends ChangeStyleCommand

  constructor: (editor, boxesSelector, newFontType) ->
    super editor, boxesSelector, {'font-family': newFontType}