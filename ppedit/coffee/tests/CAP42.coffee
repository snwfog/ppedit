#= require <ppeditTest.coffee>

ppeditDescribe "A test for issue CAP-42 : As a user, I want to change the opacity of elements in my work area.", ->

  it "drag the slider button to change the box opacity", ->

    # $(".ppedit-slider").click()
    expect($(".editor").find('.ppedit-box')).toHaveLength(1)