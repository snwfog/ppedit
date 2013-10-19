#= require <ppeditTest.coffee>

ppeditDescribe "A test for issue CAP-44 : As a user,  I want options to show or hide the grid, and snap or unsnap my elements in the work area.", ->
  it "adds a box on grid button click", ->

    expect($(".ppedit-grid")).toHaveCss({display: "block"})
    $(".gridElementBtn").click()
    expect($(".ppedit-grid")).toHaveCss({display: "none"})
