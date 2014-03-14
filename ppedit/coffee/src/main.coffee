#= require PPEditor

###
FooBar jQuery Plugin v1.0 - It makes Foo as easy as coding Bar (?).
Release: 19/04/2013
Author: Joe Average <joe@average.me>

http://github.com/joeaverage/foobar

Licensed under the WTFPL license: http://www.wtfpl.net/txt/copying/
###
(($, window, document) ->
  # Prepare your internal $this reference.
  $this = undefined

  # Store your default settings in something "private".
  # The simplest way to do so is to abide by the convention that anything
  # named with a leading underscore is part of the private API (a well-known
  # interface contract in the JavaScript community).
  _settings =
    default: 'cool!'

  # You *may* rely on internal, private objects:
  _flag = false
  _anotherState = null
  _editor = null

  # This is your public API (no leading underscore, see?)
  # All public methods must return $this so your plugin is chainable.
  methods =
    init: (options) ->
      $this = $(@)
      # The settings object is available under its name: _settings. Let's
      # expand it with any custom options the user provided.
      $.extend _settings, (options or {})
      # Do anything that actually inits your plugin, if needed, right now!
      # An important thing to keep in mind, is that jQuery plugins should be
      # built so that one can apply them to more than one element, like so:
      #
      #  $('.matching-elements, #another-one').foobar()
      #
      # It means the $this object we populated using @ (this) is to be
      # considered an array of selectors, and one must always perform
      # computations while iterating over them:
      #
      #  $this.each (index, el) ->
      #    # do something with el
      #
      _editor = new PPEditor $this
      _editor.buildElement()
      $this.append _editor.element
      _editor.bindEvents()

      options.onload() if options.onload?
      return $this

    doSomething: (what) ->
      # Another public method that people can call and rely on to do "what".
      return $this

    # This method is often overlooked.
    destroy: ->
      # Do anything to clean it up (nullify references, unbind events…).
      return $this

    save: ->
      return _editor.commandManager.getUndoJSON()

    allHunks: ->
      return _editor.area.boxesContainer.getAllHunks()

    clearHistory: ->
      _editor.commandManager.clearHistory()
      return $this

    load: (options) ->
      _editor.load options.hunks
      return $this

  # This is your private API. Most of your plugin code should go there.
  # The name "_internals" is by no mean mandatory: pick something you like, don't
  # forget the leading underscore so that the code is self-documented.
  # Those methods do not need to return $this. You may either have them working
  # by side-effects (modifying internal objects, see above) or, in a more
  # functionnal style, pass all required arguments and return a new object.
  # You can access the …settings, or other private methods using …internals.method,
  # as expected.
  _internals =
  # this toggles our "global" yet internal flag:
    toggleFlag: ->
      _flag = !_flag

  # Here is another important part of a proper plugin implementation: the clean
  # namespacing preventing from cluttering the $.fn namespace. This explains why
  # we went the extra miles of providing a pair of public and private APIs.
  # This is also the place where you specify the name of your plugin in your code.
  $.fn.ppedit = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method
      methods.init.apply this, arguments
    else
      $.error "Method " + method + " does not exist on jquery.ppedit"

  ###
  # contentloaded.js
  #
  # Author: Diego Perini (diego.perini at gmail.com)
  # Summary: cross-browser wrapper for DOMContentLoaded
  # Updated: 20101020
  # License: MIT
  # Version: 1.2
  #
  # URL:
  # http://javascript.nwbox.com/ContentLoaded/
  # http://javascript.nwbox.com/ContentLoaded/MIT-LICENSE
  ###

  # @win window reference
  # @fn function reference
  # contentLoaded = (win, fn) ->
  #   done = false
  #   top = true
  #   doc = win.document
  #   root = doc.documentElement
  #   add = (if doc.addEventListener then "addEventListener" else "attachEvent")
  #   rem = (if doc.addEventListener then "removeEventListener" else "detachEvent")
  #   pre = (if doc.addEventListener then "" else "on")
  #   init = (e) ->
  #     return  if e.type is "readystatechange" and doc.readyState isnt "complete"
  #     ((if e.type is "load" then win else doc))[rem] pre + e.type, init, false
  #     fn.call win, e.type or e  if not done and (done = true)

  #   poll = ->
  #     try
  #       root.doScroll "left"
  #     catch e
  #       setTimeout poll, 50
  #       return
  #     init "poll"

  #   unless doc.readyState is "complete"
  #     if doc.createEventObject and root.doScroll
  #       try
  #         top = not win.frameElement
  #       poll()  if top
  #     doc[add] pre + "DOMContentLoaded", init, false
  #     doc[add] pre + "readystatechange", init, false
  #     win[add] pre + "load", init, false

  # ppeditorLoaded = ->
  #   $this.trigger("ppeditor.loaded")

  # contentLoaded(window, ppeditorLoaded)
) jQuery, window, document