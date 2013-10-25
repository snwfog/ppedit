#= require ChangeStyleCommand
#= require RemoveBoxesCommand
#= require CreateBoxesCommand
#= require CopyBoxesCommand
#= require MoveBoxCommand

class CommandFactory

  createChangeFontSizeCommand: (editor, boxesSelector, newFontSize) ->
    return new ChangeStyleCommand editor, boxesSelector, {'font-size': newFontSize}

  createChangeFontTypeCommand: (editor, boxesSelector, newFontType) ->
    return new ChangeStyleCommand editor, boxesSelector, {'font-family': newFontType}

  createChangeFontWeightCommand: (editor, boxesSelector, enable) ->
    fontWeightValue = if enable then 'bold' else 'normal'
    return new ChangeStyleCommand editor, boxesSelector, {'font-weight': fontWeightValue}

  createChangeItalicFontCommand: (editor, boxesSelector, enable) ->
    styleValue = if enable then 'italic' else 'normal'
    return new ChangeStyleCommand editor, boxesSelector, {'font-style': styleValue}

  createChangeUnderlineFontCommand: (editor, boxesSelector, enable) ->
    styleValue = if enable then 'underline' else 'none'
    return new ChangeStyleCommand editor, boxesSelector, {'text-decoration': styleValue}

  createRightAlignmentCommand: (editor, boxesSelector) ->
    return new ChangeStyleCommand editor, boxesSelector, {'text-align': 'right'}

  createLeftAlignmentCommand: (editor, boxesSelector) ->
    return new ChangeStyleCommand editor, boxesSelector, {'text-align': 'left'}

  createCenterAlignmentCommand: (editor, boxesSelector) ->
    return new ChangeStyleCommand editor, boxesSelector, {'text-align': 'center'}

  createMoveBoxCommand: (box, toPosition, fromPosition) ->
    return new MoveBoxCommand box, toPosition, fromPosition

  createRemoveBoxesCommand: (editor, boxesSelector) ->
    return new RemoveBoxesCommand editor, boxesSelector

  createCopyBoxesCommand: (editor, boxesClones) ->
    return new CopyBoxesCommand editor, boxesClones

  createCreateBoxesCommand: (editor, optionsList) ->
    return new CreateBoxesCommand editor, optionsList