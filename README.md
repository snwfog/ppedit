PPedit
======

PPedit is a web based WYSIWYG editor written as a JQuery plugin for the PeerPen project:

##Basic Usage Template

    <!DOCTYPE html>
    <html>
      <head>
	    <!-- Bootsrap latest compiled and minified CSS -->
	    <link href="libs/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
	
	    <!-- Optional theme -->  
	    <link rel="stylesheet" href="libs/bootstrap/css/bootstrap-theme.min.css">
	
	    <!-- Bootstrap compatible widgets -->
	    <link href="libs/bootstrap/css/slider.css" rel="stylesheet" media="screen">
	    <link href="libs/bootstrap/css/colpick.css" rel="stylesheet" media="screen">
	
	    <!-- Custom Css -->
	    <link rel="stylesheet" href="ppedit/css/style.min.css" type="text/css"> 
	    <link href="ppedit/css/ppedit.css" rel="stylesheet" media="screen"> 
      </head>
      
      <body>

        <div class="editor"></div>
      
	    <!-- jQuery - Non-compatible with IE8 and below -->
	    <script src="libs/jquery/jquery-2.0.3.min.js"></script>
	
	    <!-- Bootstrap lib -->
	    <script src="libs/bootstrap/js/bootstrap.min.js"></script>
	    <script src="libs/bootstrap/js/bootstrap-slider.js"></script>
	    <script src="libs/bootstrap/js/colpick.js"></script>
	
	    <!- Other 3rd party libs -->
	    <script src="libs/jsSHA/src/sha256.js"></script>
	    <script src="libs/cssjson/cssjson.js"></script>
	    
	    <!-- PPedit plugin -->
	    <script src="ppedit/js/ppedit.js"></script>
		    
	    <script>
	    $(document).ready(function()
	    {
	        $(".editor").ppedit();
	    });        
	    </script>
      </body>
    </html>

##API Reference

The PPEdit plugin exposes the following interface:

 - `.ppedit(options)`
   - Loads an empty instance of the editor. Attach a callback to the **onload** property of the options paramater that is going to be called upon successfull loading.

 - `.ppedit('load', hunksArray)`
   - Populates the editor with the boxes information defined in the passed options parameter.
   - Example :

```
        .ppedit('load',{
             hunks:
             [
               {
                 "box-id-1":{
                    html:'<div class="ppedit-box" id="box-id-1">box-id-1 contents in page 1</div>',
                    name:'box-name-1'
                   },
                 "box-id-2":{
                    html:'<div class="ppedit-box" id="box-id-2">box-id-2 contents in page 1</div>',
                    name:'box-name-2'
                   }
               },
               {
                 "box-id-3":{
                    html:'<div class="ppedit-box" id="box-id-3">box-id-3 contents in page 2</div>',
                    name:'box-name-3'
                   },
                 "box-id-4":{
                    html:'<div class="ppedit-box" id="box-id-4">box-id-4 contents in page 2</div>',
                    name:'box-name-4'
                   }
               }
             ]
         });
```


- `.ppedit('save')`
  - Returns a json string specifying the boxes that have been created, modified and/or removed since the editor has been loaded.

- `.ppedit('allHunks')`
  - Returns a JSON string containing a description of
  all the boxes currently existing in the editor.

- `.ppedit('clearHistory')`
  - Deletes the history of the modifications of the editor contents performed since the editor has been loaded, this method should be called every time after a 'save' opertation succeeded.

##Development environment installation

First clone this repository then follow the instructions below.

### Install Coffee-Script

 - Download and run [Node.js installer](http://nodejs.org/download/).
 - Run on the command line (May require Root/Admin privilieges):

	`npm install -g coffee-script`

    *NOTE : For windows users, you need to cd into your nodejs installation directory to run the `npm` command
    (Default is C:/Program Files/nodejs).*

 - That's all. You can now run the `coffee` command from any directory.

### Install [Coffee-script-concat](https://github.com/fairfieldt/coffeescript-concat)

 - Run on the command line (May require Root/Admin privilieges):

	`npm install -g coffeescript-concat`

##Development Instructions

### Coding

 - Never edit directly the file ppedit/js/ppedit.js. This file is generated automatically from the *.coffee files located in the ppedit/coffee/src folder.

 - To generate the ppedit.js file, use the following commands :
	- `cd (ppedit project root)/ppedit/                `
	- `coffeescript-concat -R coffee/src | coffee -s --compile > js/ppedit.js`

 - Open the main.html file on a browser to see what the editor looks like

 - You can also run the `compileCoffee.sh` file to generate the ppedit.js and the ppedit-test.js in one command.

### Testing

 - Never edit directly the file ppedit/js/ppedit-tests.js. This file is generated automatically from the *.coffee files located in the ppedit/coffee/tests folder.

 - To generate the ppedit-tests.js file, use the following commands :
    - `cd (ppedit project root)/ppedit/                `
	- `coffeescript-concat -R coffee/tests | coffee -s --compile > js/ppedit-tests.js`

 - Open the tests.html file on a browser to run and see the results of the tests. Clear your browser cache and refresh your page to run the tests again. *NOTE: never move the mouse while the tests are running, as it can falsify some of the tests.*.

  - You can also run the `compileCoffee.sh` file to generate the ppedit.js and the ppedit-test.js in one command.

  - Check the file `CAPTemplate.coffee` to find out how to write a ppedit jasmine test suite.

##Third Party Librairies Used

###Coding :

 - [jQuery](http://jquery.com/) : provides an API simpler than the built-in Javascript for HTML document traversal and manipulation, event handling, animation, and Ajax.

 - [CoffeeScript](http://coffeescript.org/) : CoffeeScript is a little language that compiles into JavaScript.

 - [coffeescript-concat](https://github.com/fairfieldt/coffeescript-concat) : coffeescript-concat is a utility that preprocesses and concatenates CoffeeScript source files, allowing to create package javascript source files.

###Testing :

 - [Jasmine](http://pivotal.github.io/jasmine/) : Jasmine is a behavior-driven testing framework for testing JavaScript code.

 - [Jasmine-query](https://github.com/velesin/jasmine-jquery) : jasmine-jquery provides two extensions for Jasmine.

 - [jQuery Simulate](https://github.com/jquery/jquery-simulate) : jQuery Simulate allows to simulate mouseEvents and keyBoards events on a browser.

 - [jQuery Simulate Extended Plugin 1.2.0](https://github.com/j-ulrich/jquery-simulate-ext) : The simulate extended plugin provides methods for simulating complex user interactions based on the jQuery.simulate() plugin.
