#= require <ppeditTestCustomMatchers.coffee>

ppeditDescribe = (suitDescription, specDefinitions) ->

  describe '', ->

    beforeEach ->
      @addMatchers ppeditMatchers
      $(".editor").ppedit()

    afterEach ->
      $('.editor').children().remove()

    describe suitDescription, specDefinitions