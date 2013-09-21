#= require Controller

( ($) ->
  root = null
  $.fn.ppedit = () ->

    controller = new Controller this

    return this;

) jQuery