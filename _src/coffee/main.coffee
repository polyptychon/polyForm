global.jQuery = require "jquery"
require "select2/select2"
require "angular/angular"
require "angular-ui-utils/modules/utils"
require "../js/select2"

module.exports =
  angular.module('PolyForm', ['ui.utils', 'ui.select2'])
  .directive("FormTabs", require("./directives/FormTabs"))
  .directive("FormTab", require("./directives/FormTab"))
