cd ppedit
coffee coffeescript-concat.coffee -I coffee/src | coffee -s --compile > js/ppedit.js
coffee coffeescript-concat.coffee -I coffee/tests | coffee -s --compile > js/ppedit-tests.js
