// Generated by CoffeeScript 1.6.3
(function() {
  var Controller, CreateBoxCommand, EditorManager, ICommand, MoveBoxCommand,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ICommand = (function() {
    function ICommand(root) {
      this.root = root;
    }

    return ICommand;

  })();

  MoveBoxCommand = (function(_super) {
    __extends(MoveBoxCommand, _super);

    function MoveBoxCommand(box, newX, newY) {
      this.box = box;
      this.newX = newX;
      this.newY = newY;
      this.prevStyle = this.box.get(0).style;
    }

    MoveBoxCommand.prototype.execute = function() {
      return this.box.css({
        left: this.newX + 'px',
        top: this.newY + 'px'
      });
    };

    MoveBoxCommand.prototype.undo = function() {
      return this.box.css({
        left: this.prevStyle.left,
        top: this.prevStyle.top
      });
    };

    return MoveBoxCommand;

  })(ICommand);

  CreateBoxCommand = (function(_super) {
    __extends(CreateBoxCommand, _super);

    function CreateBoxCommand(root, options) {
      this.root = root;
      this.options = options;
      CreateBoxCommand.__super__.constructor.call(this, this.root);
      this.box = null;
    }

    CreateBoxCommand.prototype.execute = function() {
      var settings;
      settings = $.extend({
        left: '50px',
        top: '50px',
        width: '100px',
        height: '200px'
      }, this.options);
      this.box = $('<div></div>').addClass('ppedit-box').attr('id', $.now()).css(settings).attr('draggable', true).on('dragstart', function(event) {
        event.originalEvent.dataTransfer.setData('mouseOffsetX', event.originalEvent.offsetX);
        event.originalEvent.dataTransfer.setData('mouseOffsetY', event.originalEvent.offsetY);
        return event.originalEvent.dataTransfer.setData('boxId', this.id);
      });
      return this.root.append(this.box);
    };

    CreateBoxCommand.prototype.undo = function() {
      return this.root.remove(this.box);
    };

    return CreateBoxCommand;

  })(ICommand);

  EditorManager = (function() {
    function EditorManager(root) {
      this.root = root;
      this.undoStack = [];
      this.redoStack = [];
      this.build();
    }

    EditorManager.prototype.build = function() {
      var _this = this;
      return this.root.addClass("ppedit-container").on('dragover', function(event) {
        return event.preventDefault();
      }).on('drop', function(event) {
        var boxId, boxNewX, boxNewY;
        event.preventDefault();
        boxId = event.originalEvent.dataTransfer.getData('boxId');
        boxNewX = event.originalEvent.offsetX - event.originalEvent.dataTransfer.getData('mouseOffsetX');
        boxNewY = event.originalEvent.offsetY - event.originalEvent.dataTransfer.getData('mouseOffsetY');
        return _this.moveBox($('#' + boxId), boxNewX, boxNewY);
      });
    };

    EditorManager.prototype.createBox = function(options) {
      return this.pushCommand(new CreateBoxCommand(this.root, options));
    };

    EditorManager.prototype.moveBox = function(box, newX, newY) {
      return this.pushCommand(new MoveBoxCommand(box, newX, newY));
    };

    EditorManager.prototype.pushCommand = function(command) {
      command.execute();
      return this.undoStack.push(command);
    };

    EditorManager.prototype.undo = function() {
      var lastExecutedCommand;
      if (this.undoStack.length > 0) {
        lastExecutedCommand = this.undoStack.pop;
        lastExecutedCommand.undo();
        return this.redoStack.push(lastExecutedCommand);
      }
    };

    EditorManager.prototype.redo = function() {
      if (this.redoStack.length > 0) {
        return this.pushCommand(this.redoStack.pop);
      }
    };

    return EditorManager;

  })();

  Controller = (function() {
    function Controller(root) {
      this.root = root;
      this.editorManager = new EditorManager(this.root);
    }

    Controller.prototype.start = function() {
      var createBoxbutton,
        _this = this;
      createBoxbutton = $("<button>Create Box</button>");
      this.root.append(createBoxbutton);
      return createBoxbutton.click(function() {
        return _this.editorManager.createBox();
      });
    };

    return Controller;

  })();

  /*
  FooBar jQuery Plugin v1.0 - It makes Foo as easy as coding Bar (?).
  Release: 19/04/2013
  Author: Joe Average <joe@average.me>
  
  http://github.com/joeaverage/foobar
  
  Licensed under the WTFPL license: http://www.wtfpl.net/txt/copying/
  */


  (function($, window, document) {
    var $this, methods, _anotherState, _flag, _internals, _settings;
    $this = void 0;
    _settings = {
      "default": 'cool!'
    };
    _flag = false;
    _anotherState = null;
    methods = {
      init: function(options) {
        var controller;
        $this = $(this);
        $.extend(_settings, options || {});
        controller = new Controller($this);
        controller.start();
        return $this;
      },
      doSomething: function(what) {
        return $this;
      },
      destroy: function() {
        return $this;
      }
    };
    _internals = {
      toggleFlag: function() {
        return _flag = !_flag;
      }
    };
    return $.fn.ppedit = function(method) {
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === "object" || !method) {
        return methods.init.apply(this, arguments);
      } else {
        return $.error("Method " + method + " does not exist on jquery.ppedit");
      }
    };
  })(jQuery, window, document);

}).call(this);
