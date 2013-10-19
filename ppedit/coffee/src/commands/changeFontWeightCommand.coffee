#= require Box
#= require ChangeStyleCommand

class ChangeFontWeightCommand extends ChangeStyleCommand

  constructor: (editor, boxesSelector, enable) ->
    fontWeightValue = if enable then 'bold' else 'normal'
    super editor, boxesSelector, {'font-weight': fontWeightValue}