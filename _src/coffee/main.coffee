global.$ = global.jQuery = $ = require "jquery"
require "bootstrapify"
require "select2/select2"
require "bootstrap-datepicker/js/bootstrap-datepicker"
require "lodash"

require 'angular/angular'
require 'angular-ui-utils/modules/validate/validate'
require 'angular-ui-utils/modules/mask/mask'
#require 'angular-sanitize'
#require "ui-select"
require "pen"
require "pen/src/markdown"
require "../js/angular-ui-select2"

module.exports =
  angular.module('PolyForm', ['ui.validate','ui.mask','ui.select2'])
  #angular.module('PolyForm', ['ngSanitize','ui.validate','ui.mask','ui.select2','ui.select'])
  .directive("formTabs", require("./directives/form-tabs/FormTabs.coffee"))
  .directive("formTab", require("./directives/form-tab/FormTab.coffee"))
  .directive("formControl", ['$parse', require("./directives/form-control/FormControl.coffee")])
  .directive("formGroup", require("./directives/form-group/FormGroup.coffee"))
  .directive("inputGroup", require("./directives/input-group/InputGroup.coffee"))
  .directive("inputGroupAddon", require("./directives/input-group-addon/InputGroupAddon.coffee"))
  .directive("errorMessage", require("./directives/error-message/ErrorMessage.coffee"))
  .directive("validIcon", require("./directives/valid-icon/ValidIcon.coffee"))
  .directive("loaderIcon", require("./directives/loader-icon/LoaderIcon.coffee"))
  .directive("dateInput", require("./directives/date-input/DateInput.coffee"))
  .directive("popover", require("./directives/popover/Popover.coffee"))
  .directive("pen", require("./directives/sofish-pen/Pen.coffee"))
  .directive("isEqual", require("./directives/is-equal/IsEqual.coffee"))
  .directive("disableValidationWhenHidden", require("./directives/disable-validation-when-hidden/DisableValidationWhenHidden.coffee"))
  .directive("isUnique", ['$timeout', '$http', require("./directives/is-unique/IsUnique.coffee")])
  .directive("remoteValidation", ['$timeout', '$http', require("./directives/remote-validation/RemoteValidation.coffee")])
  .directive("jsonResource", ['$timeout', '$http', require("./directives/json-resource/JsonResource.coffee")])
  .directive("uiSelect2Query", ['$timeout', '$http', require("./directives/ui-select2-query/UiSelect2Query.coffee")])
  .directive("input", ['$parse', require("./directives/defaultValue/DefaultValue.coffee")])
  .directive("select", ['$parse', require("./directives/defaultValue/DefaultValue.coffee")])
  .directive("textarea", ['$parse', require("./directives/defaultValue/DefaultValue.coffee")])
