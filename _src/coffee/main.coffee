global.jQuery = require "jquery"
require "angular/angular"
require "../js/select2"

module.exports =
  angular.module('PolyForm', ['ui.select2'])
  .directive("formTabs", require("./directives/FormTabs.coffee"))
  .directive("formTab", require("./directives/FormTab.coffee"))
