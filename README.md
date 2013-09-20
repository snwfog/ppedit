 PPedit
======

PPedit is a web based WYSIWYG editor written as a JQuery plugin for the PeerPen project:

##Basic Usage Template

    <!DOCTYPE html>
    <html>
      <head>
        <link href="ppedit/css/ppedit.css" rel="stylesheet" media="screen">    
      </head>
      <body>
      
        <div class="editor"></div>
      
        <!-- PPedit REQUIRES jQuery -->
        <script src="libs/jquery/jquery-2.0.3.min.js"></script>
        
        <script src="ppedit/js/ppedit.js"></script>
    
        <script>
        $(document).ready(function()
        {
            $(".editor").ppedit();
        });        
        </script>
      </body>
    </html>

##Development environment installation

First clone this repository then follow the instructions below.

### Install Coffee-Script

 -  Download and run [Node.js installer](http://nodejs.org/download/).
 - Run on the command line (May require Root/Admin privilieges): 

    npm install -g coffee-script

 - That's all. You can now run `coffee` from any directory.

### Install [Coffee-script-concat ](https://github.com/fairfieldt/coffeescript-concat)

 - Run on the command line (May require Root/Admin privilieges): 

    npm install -g coffee-script-concat

### Install Selenium

    TBA

##Development Instruction

 - Never edit directly the file ppedit/js/ppedit.js. This file is generated automatically from the *.coffee files located in the ppedit/coffee/ folder.
 - To generate the ppedit.js file, use the following commands :

    cd (ppedit project root)/ppedit/    
    coffeescript-concat -I coffee/ -o js/ppedit.js
