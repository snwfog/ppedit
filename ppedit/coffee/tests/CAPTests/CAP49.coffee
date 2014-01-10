#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe 'A test for issue "CAP-49 : As a backend developer, I want an API from PPEdit that provides a changeset made on a particular resume so that I can persist it on the backend"', ->

  boxObject =
    1234 : '<div class="ppedit-box" tabindex="0" contenteditable="true" id="1234" style="left: 54px; top: 90px; width: 163px; height: 119px; font-family: \'Times New Roman\'; font-size: 100%; font-weight: normal; text-decoration: none; font-style: normal; z-index: 0; text-align: left; vertical-align: bottom;"></div>'

  it "identifies boxes that were created then deleted during current editing as non existent", ->
    addBox 1

    simulateBoxDblClick $('.ppedit-box'), =>
      requestDelete()

      result = JSON.parse $('.editor').ppedit('save')
      expect(result.removed.length).toEqual 0
      expect(result.created.length).toEqual 0
      expect(result.modified.length).toEqual 0

  it "identifies two boxes newly created as saved when the saving API is called", ->
    addBox 2

    result = JSON.parse $('.editor').ppedit('save')
    expect(result.removed.length).toEqual 0
    expect(result.created.length).toEqual 2
    expect(result.modified.length).toEqual 0

  it "identifies a new box as created when the saving API is called", ->
    addBox 1

    $('.ppedit-box').simulate 'click'

    # Simulating ctrl + delete
    $('.ppedit-box-container').simulate 'key-combo', {combo: 'ctrl+46'}; # If Windows
    $('.ppedit-box-container').simulate 'key-combo', {combo: 'meta+8'}; # If Mac

    addBox 1

    result = JSON.parse $('.editor').ppedit('save')
    expect(result.removed.length).toEqual 0
    expect(result.created.length).toEqual 1
    expect(result.modified.length).toEqual 0

  it "generates a unique hash for each different hunk", ->
    addBox 1
    result = JSON.parse $('.editor').ppedit('save')

    expect(result.etag).toBeDefined()
    expect(result.etag.length).toBeGreaterThan(5)

    $(".addElementBtn").click()

    result2 = JSON.parse $('.editor').ppedit('save')

    expect(result.etag).not.toEqual(result2.etag)

  it "identifies a box which is first loaded and then deleted as removed", ->
    $('.editor').ppedit 'load', {hunks:JSON.stringify(boxObject)}

    $('.ppedit-box').simulate 'click'
    requestDelete()

    result = JSON.parse $('.editor').ppedit('save')
    expect(result.removed.length).toEqual 1
    expect(result.created.length).toEqual 0
    expect(result.modified.length).toEqual 0

  it "identifies a box which is first loaded and then moved as modified", ->
    $('.editor').ppedit 'load', {hunks:JSON.stringify(boxObject)}

    moveBox $('.ppedit-box'), {dx:100, dy:50}

    result = JSON.parse $('.editor').ppedit('save')
    expect(result.removed.length).toEqual 0
    expect(result.created.length).toEqual 0
    expect(result.modified.length).toEqual 1


