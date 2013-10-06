cd ppedit
coffee coffeescript-concat.coffee -R coffee/src | coffee -s --compile > js/ppedit.js
coffee coffeescript-concat.coffee -R coffee/tests | coffee -s --compile > js/ppedit-tests.js
