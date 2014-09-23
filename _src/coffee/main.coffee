global.jQuery = require "jquery"
require "angular/angular"
require "../js/select2"

module.exports =
  angular.module('PolyForm', ['ui.select2'])
  .directive("formTabs", require("./directives/FormTabs.coffee"))
  .directive("formTab", require("./directives/FormTab.coffee"))
  .directive("formControl", require("./directives/FormControl.coffee"))
  .directive("formGroup", require("./directives/FormGroup.coffee"))
  .directive("inputGroup", require("./directives/InputGroup.coffee"))
  .directive("inputGroupAddon", require("./directives/InputGroupAddon.coffee"))
  .directive("errorMessage", require("./directives/ErrorMessage.coffee"))
  .directive("validIcon", require("./directives/ValidIcon.coffee"))
  .directive("loaderIcon", require("./directives/LoaderIcon.coffee"))
  .directive("dateInput", require("./directives/DateInput.coffee"))
