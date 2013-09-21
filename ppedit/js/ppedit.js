// Generated by CoffeeScript 1.6.3
var Controller, EditorManager;

EditorManager = (function() {
  function EditorManager(root) {
    this.root = root;
  }

  EditorManager.prototype.createBox = function(options) {
    var newBox, settings;
    settings = $.extend({
      left: '50px',
      top: '50px',
      width: '100px',
      height: '200px'
    }, options);
    newBox = $('<div class="ppedit-box"><div>').css(settings).resizable();
    return this.root.append(newBox);
  };

  EditorManager.prototype.undo = function() {};

  EditorManager.prototype.redo = function() {};

  return EditorManager;

})();

Controller = (function() {
  function Controller(root) {
    var createBoxbutton;
    this.root = root;
    this.editorManager = new EditorManager(this.root);
    this.root = this.root.addClass("ppedit-container");
    createBoxbutton = $("<button>Create Box</button>");
    this.root.append(createBoxbutton);
    createBoxbutton.click(function() {
      return this.editorManager.createBox();
    });
  }

  return Controller;

})();

(function($) {
  var root;
  root = null;
  return $.fn.ppedit = function() {
    var controller;
    controller = new Controller(this);
    return this;
  };
})(jQuery);
