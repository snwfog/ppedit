#= require ChangeStyleCommand
#= require RemoveBoxesCommand
#= require CreateBoxesCommand
#= require CopyBoxesCommand
#= require MoveBoxCommand
#= require ChangeDepthCommand
#= require ChangeBoxContentCommand
#= require LoadBoxesCommand
#= require ChangeBoxOpacityCommand

###
This class is responsible for creating and providing commands on the fly.
###
class CommandFactory

  createChangeFontSizeCommand: (editor, editPage, boxesSelector, newFontSize) ->
    return new ChangeStyleCommand editor, editPage, boxesSelector, {'font-size': newFontSize}

  createChangeFontTypeCommand: (editor, editPage, boxesSelector, newFontType) ->
    return new ChangeStyleCommand editor, editPage, boxesSelector, {'font-family': newFontType}

  createChangeFontWeightCommand: (editor, editPage, boxesSelector, enable) ->
    fontWeightValue = if enable then 'bold' else 'normal'
    return new ChangeStyleCommand editor, editPage, boxesSelector, {'font-weight': fontWeightValue}

  createChangeItalicFontCommand: (editor, editPage, boxesSelector, enable) ->
    styleValue = if enable then 'italic' else 'normal'
    return new ChangeStyleCommand editor, editPage, boxesSelector, {'font-style': styleValue}

  createChangeUnderlineFontCommand: (editor, editPage, boxesSelector, enable) ->
    styleValue = if enable then 'underline' else 'none'
    return new ChangeStyleCommand editor, editPage, boxesSelector, {'text-decoration': styleValue}

  createRightAlignmentCommand: (editor, editPage, boxesSelector) ->
    return new ChangeStyleCommand editor, editPage, boxesSelector, {'text-align': 'right'}

  createLeftAlignmentCommand: (editor, editPage, boxesSelector) ->
    return new ChangeStyleCommand editor, editPage, boxesSelector, {'text-align': 'left'}

  createCenterAlignmentCommand: (editor, editPage, boxesSelector) ->
    return new ChangeStyleCommand editor, editPage, boxesSelector, {'text-align': 'center'}

  createChangeTextColorCommand: (editor, editPage, boxesSelector, newColor) ->
    return new ChangeStyleCommand editor, editPage, boxesSelector, {'color': '#' + newColor}

  createChangeOpacityCommand: (editor, editPage, boxId, prevVal, newVal) ->
    return new ChangeBoxOpacityCommand editor, editPage, boxId, prevVal, newVal

  createMoveBoxCommand: (box, toPosition, fromPosition) ->
    return new MoveBoxCommand box, toPosition, fromPosition

  createRemoveBoxesCommand: (editor, editContainer, boxesSelector) ->
    return new RemoveBoxesCommand editor, editContainer, boxesSelector

  createCopyBoxesCommand: (editor, editPage, boxesClones) ->
    return new CopyBoxesCommand editor, editPage, boxesClones

  createCreateBoxesCommand: (editor, editContainer,optionsList) ->
    return new CreateBoxesCommand editor, editContainer, optionsList

  createCreateChangeBoxContentCommand: (box, prevContent, newContent) ->
    return new ChangeBoxContentCommand box, prevContent, newContent

  createMoveUpCommand: (editor, editContainer, boxSelector) ->
    return new ChangeDepthCommand editor, editContainer, boxSelector, true

  createMoveDownCommand: (editor, editContainer, boxSelector) ->
    return new ChangeDepthCommand editor, editContainer, boxSelector, false

  createLoadBoxesCommand: (editor, jsonBoxes) ->
    return new LoadBoxesCommand editor, jsonBoxes
