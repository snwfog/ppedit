#= require Box
#= require ChangeStyleCommand

class UnderlineFontCommand extends ChangeStyleCommand

  constructor: (editor, boxesSelector, enable) ->
    styleValue = if enable then 'underline' else 'none'
    super editor, boxesSelector, {'text-decoration': styleValue}