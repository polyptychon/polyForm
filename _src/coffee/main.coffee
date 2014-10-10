global.jQuery = $ = require "jquery"
require "bootstrapify"
require "select2/select2"
require "bootstrap-datepicker/js/bootstrap-datepicker"
require "lodash"

require 'angular'
require "../js/angular-ui-select2"

module.exports =
  angular.module('PolyForm', ['ui.select2'])
  .directive("formTabs", require("./directives/form-tabs/FormTabs"))
  .directive("formTab", require("./directives/form-tab/FormTab"))
  .directive("formControl", require("./directives/form-control/FormControl"))
  .directive("formGroup", require("./directives/form-group/FormGroup"))
  .directive("inputGroup", require("./directives/input-group/InputGroup"))
  .directive("inputGroupAddon", require("./directives/input-group-addon/InputGroupAddon"))
  .directive("errorMessage", require("./directives/error-message/ErrorMessage"))
  .directive("validIcon", require("./directives/valid-icon/ValidIcon"))
  .directive("loaderIcon", require("./directives/loader-icon/LoaderIcon"))
  .directive("dateInput", require("./directives/date-input/DateInput"))
  .directive("popover", require("./directives/popover/Popover"))
  .directive("isEqual", require("./directives/is-equal/IsEqual"))
  .directive("disableValidationWhenHidden", require("./directives/disable-validation-when-hidden/DisableValidationWhenHidden"))
  .directive("isUnique", ['$timeout', '$http', require("./directives/is-unique/IsUnique")])
  .directive("jsonResource", ['$timeout', '$http', require("./directives/json-resource/JsonResource")])
  .directive("uiSelect2Query", ['$timeout', '$http', require("./directives/ui-select2-query/UiSelect2Query")])
