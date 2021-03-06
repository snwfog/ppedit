#= require ChangeStyleCommand
#= require RemoveBoxesCommand
#= require CreateBoxesCommand
#= require CopyBoxesCommand
#= require MoveBoxCommand
#= require ChangeDepthCommand
#= require ChangeBoxContentCommand
#= require LoadBoxesCommand
#= require ChangeBoxOpacityCommand
#= require AddOrRemoveCommand
#= require ChangeBoxNameCommand

###
This class is responsible for creating and providing commands on the fly.
###
class CommandFactory

  createChangeFontSizeCommand: (editor, boxesSelector, newFontSize) ->
    return new ChangeStyleCommand editor, boxesSelector, {'font-size': newFontSize}

  createChangeFontTypeCommand: (editor, boxesSelector, newFontType) ->
    return new ChangeStyleCommand editor, boxesSelector, {'font-family': newFontType}

  createChangeLetterSpaceCommand: (editor, boxesSelector, newletterSpace) ->
    return new ChangeStyleCommand editor, boxesSelector, {'letter-spacing': newletterSpace}

  createChangeLineHeightCommand: (editor, boxesSelector, newLineHeight) ->
    return new ChangeStyleCommand editor, boxesSelector, {'line-height': newLineHeight}

  createChangePaddingCommand: (editor, boxesSelector, newPadding) ->
    return new ChangeStyleCommand editor, boxesSelector, {'padding': newPadding}

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

  createChangeTextColorCommand: (editor, boxesSelector, newColor) ->
    return new ChangeStyleCommand editor, boxesSelector, {'color': '#' + newColor}

  createChangeOpacityCommand: (editor, editPage, boxId, prevVal, newVal) ->
    return new ChangeBoxOpacityCommand editor, editPage, boxId, prevVal, newVal

  createMoveBoxCommand: (box, pageNum, toPosition, fromPosition) ->
    return new MoveBoxCommand box, pageNum, toPosition, fromPosition

  createRemoveBoxesCommand: (editor, pageNum, boxesSelector) ->
    return new RemoveBoxesCommand editor, pageNum, boxesSelector

  createCopyBoxesCommand: (editor, editPage, boxesClones) ->
    return new CopyBoxesCommand editor, editPage, boxesClones

  createCreateBoxesCommand: (editor, editContainer,optionsList) ->
    return new CreateBoxesCommand editor, editContainer, optionsList

  createCreateChangeBoxContentCommand: (box, pageNum, prevContent, newContent) ->
    return new ChangeBoxContentCommand box, pageNum, prevContent, newContent

  createMoveUpCommand: (editor, pageNum, boxSelector) ->
    return new ChangeDepthCommand editor, pageNum, boxSelector, true

  createMoveDownCommand: (editor, pageNum, boxSelector) ->
    return new ChangeDepthCommand editor, pageNum, boxSelector, false

  createLoadBoxesCommand: (editor, jsonBoxes) ->
    return new LoadBoxesCommand editor, jsonBoxes

  createAddPageCommand: (editor) ->
    return new AddOrRemoveCommand editor, true

  createRemovePageCommand: (editor, pageNum) ->
    return new AddOrRemoveCommand editor, false, pageNum

  createChangeBoxNameCommand: (editor, boxId, pageNum, prevName, newName) ->
    return new ChangeBoxNameCommand editor, boxId, pageNum, prevName, newName
