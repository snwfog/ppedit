cd ppedit
coffeescript-concat -I coffee | coffee -s --compile > js/ppedit.js 
coffeescript-concat -I coffee/tests | coffee -s --compile > js/ppedit-tests.js 
