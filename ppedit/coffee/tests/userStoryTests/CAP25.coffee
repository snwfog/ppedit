#= require <ppeditTest.coffee>
#= require <ppeditTestHelper.coffee>

ppeditDescribe "A test for issue CAP-25 : As a user, I want to name my document, so that I can distinguish between my documents", ->

  it "can input text inside the textarea to name document", ->
    $('.addElementBtn').val('documentName')
    expect($('.addElementBtn')).toHaveValue('documentName')