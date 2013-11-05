#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe 'A test for issue "CAP-49 : As a backend developer, I want an API from PPEdit that provides a changeset made on a particular resume so that I can persist it on the backend"', ->

  it "identifies boxes that existed before current editing and that were then deleted as removed boxes when the saving API is called.", ->

    addBox 1

    $('.ppedit-box').simulate 'click'

    # Simulating ctrl + delete
    $('.ppedit-box-container').simulate 'key-combo', {combo: 'ctrl+46'}; # If Windows
    $('.ppedit-box-container').simulate 'key-combo', {combo: 'meta+8'}; # If Mac

    result = JSON.parse $('.editor').ppedit('save')
    expect(result.removed.length).toEqual 0
    expect(result.created.length).toEqual 0
    expect(result.modified.length).toEqual 0

  it "identifies if two boxes are created and is saved when the saving API is called.", ->
    addBox 2

    result = JSON.parse $('.editor').ppedit('save')
    expect(result.removed.length).toEqual 0
    expect(result.created.length).toEqual 2
    expect(result.modified.length).toEqual 0

  it "identifies if a box created, then removed and then created when the saving API is called.", ->
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
