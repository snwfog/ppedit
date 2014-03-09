#= require <ppeditTestCustomMatchers.coffee>

ppeditDescribe = (suitDescription, specDefinitions) ->

  describe '', ->

    beforeEach ->
      @addMatchers ppeditMatchers
      $(".editor").ppedit()

    afterEach ->
      $('.editor').find('*').off()
      $('.editor').html('')

    describe suitDescription, specDefinitions