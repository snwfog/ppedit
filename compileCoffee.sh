cd ppedit
coffeescript-concat -R coffee/src | coffee -s --compile > js/ppedit.js
coffeescript-concat -R coffee/tests | coffee -s --compile > js/ppedit-tests.js
