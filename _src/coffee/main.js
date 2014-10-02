// Generated by CoffeeScript 1.7.1
(function() {
  var $;

  global.jQuery = $ = require("jquery");

  require("bootstrapify");

  require("select2/select2");

  require("bootstrap-datepicker/js/bootstrap-datepicker");

  require("angular/angular");

  require("../js/angular-ui-select2");

  module.exports = angular.module('PolyForm', ['ui.select2']).directive("formTabs", require("./directives/FormTabs")).directive("formTab", require("./directives/FormTab")).directive("formControl", require("./directives/FormControl")).directive("formGroup", require("./directives/FormGroup")).directive("inputGroup", require("./directives/InputGroup")).directive("inputGroupAddon", require("./directives/InputGroupAddon")).directive("errorMessage", require("./directives/ErrorMessage")).directive("validIcon", require("./directives/ValidIcon")).directive("loaderIcon", require("./directives/LoaderIcon")).directive("dateInput", require("./directives/DateInput")).directive("popover", require("./directives/Popover")).directive("disableValidationWhenHidden", require("./directives/DisableValidationWhenHidden")).directive("isUnique", ['$timeout', '$http', require("./directives/IsUnique")]).directive("jsonResource", ['$timeout', '$http', require("./directives/JsonResource")]).directive("uiSelect2Query", ['$timeout', '$http', require("./directives/UiSelect2Query")]);

}).call(this);

//# sourceMappingURL=main.map
