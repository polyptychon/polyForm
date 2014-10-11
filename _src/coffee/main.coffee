global.jQuery = $ = require "jquery"
require "bootstrapify"
require "select2/select2"
require "bootstrap-datepicker/js/bootstrap-datepicker"
require "lodash"

require 'angular'
require 'angular-ui-utils/modules/validate/validate'
require 'angular-ui-utils/modules/mask/mask'
require "../js/angular-ui-select2"

module.exports =
  angular.module('PolyForm', ['ui.validate','ui.mask','ui.select2'])
  .directive("formTabs", require("./directives/form-tabs/FormTabs.coffee"))
  .directive("formTab", require("./directives/form-tab/FormTab.coffee"))
  .directive("formControl", require("./directives/form-control/FormControl.coffee"))
  .directive("formGroup", require("./directives/form-group/FormGroup.coffee"))
  .directive("inputGroup", require("./directives/input-group/InputGroup.coffee"))
  .directive("inputGroupAddon", require("./directives/input-group-addon/InputGroupAddon.coffee"))
  .directive("errorMessage", require("./directives/error-message/ErrorMessage.coffee"))
  .directive("validIcon", require("./directives/valid-icon/ValidIcon.coffee"))
  .directive("loaderIcon", require("./directives/loader-icon/LoaderIcon.coffee"))
  .directive("dateInput", require("./directives/date-input/DateInput.coffee"))
  .directive("popover", require("./directives/popover/Popover.coffee"))
  .directive("isEqual", require("./directives/is-equal/IsEqual.coffee"))
  .directive("disableValidationWhenHidden", require("./directives/disable-validation-when-hidden/DisableValidationWhenHidden.coffee"))
  .directive("isUnique", ['$timeout', '$http', require("./directives/is-unique/IsUnique.coffee")])
  .directive("jsonResource", ['$timeout', '$http', require("./directives/json-resource/JsonResource.coffee")])
  .directive("uiSelect2Query", ['$timeout', '$http', require("./directives/ui-select2-query/UiSelect2Query.coffee")])
