#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe "A test for issue CAP-14 : As a user, I want to reposition elements visible on my work area", ->

  it "adds a box when clicking the add element button once", ->
    addBox 1

  it "adds multiples boxes when clicking the add element button multiple times", ->
    addBox 10

  it "adds a box when doubleclicking the container", ->
    $(".ppedit-box-container").simulate 'dblclick'
    expect($ '.ppedit-box').toHaveLength 1

  it "adds 2 boxes when doubleclicking the container twice", ->
    $(".ppedit-box-container").simulate 'dblclick'
    $(".ppedit-box-container").simulate 'dblclick'
    expect($ '.ppedit-box').toHaveLength 2

  it "repositions elements with the mouse", ->
    addBox 2
    moveBox $('.ppedit-box'), {dx:150, dy:180}
    moveBox $('.ppedit-box'), {dx:100, dy:100}

  it "deletes a box when clicking on ctrl+delete", ->
    addBox 1

    $('.ppedit-box').simulate 'click'
    expect($('.ppedit-box-selected')).toHaveLength(1)

    # Simulating ctrl + delete
    $('.ppedit-box-container').simulate 'key-combo', {combo: 'ctrl+46'}; # If Windows
    $('.ppedit-box-container').simulate 'key-combo', {combo: 'meta+8'}; # If Mac

    expect($('.ppedit-box')).toHaveLength(0)
