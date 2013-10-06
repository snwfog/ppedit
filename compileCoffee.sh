cd ppedit
coffee node_modules/coffeescript-concat/coffeescript-concat.coffee -R coffee/src | coffee -s --compile > js/ppedit.js
coffee node_modules/coffeescript-concat/coffeescript-concat.coffee -R coffee/tests | coffee -s --compile > js/ppedit-tests.js
