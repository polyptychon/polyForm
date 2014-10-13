global.$ = global.jQuery = $ = require "jquery"
require "bootstrapify"
require "select2/select2"
require "bootstrap-datepicker/js/bootstrap-datepicker"
require "lodash"

require 'angular'
require 'angular-ui-utils/modules/validate/validate'
require 'angular-ui-utils/modules/mask/mask'
require "../../../../_src/js/angular-ui-select2"

require "angular-mocks/angular-mocks"
DateInput = require "../../../../_src/coffee/directives/date-input/DateInput.coffee"
template = require "./date-input-example.jade"

describe('DateInput', ->

  angular.module('myApp', ['ui.validate','ui.mask','ui.select2'])
  .directive("dateInput", DateInput)

  $compile = null
  $rootScope = null
  element = null
  scope = null

  beforeEach(angular.mock.module("myApp"))

  beforeEach(inject((_$rootScope_, _$compile_) ->
    $rootScope = _$rootScope_
    $compile = _$compile_
    scope = $rootScope

    element = $("<div></div>").html(template())

    $compile(element)(scope)
    scope.$digest()
  ))

  it("dateInput parent div should have class input-group", ->
    expect($(element).find('.input-group').length).toBe 1
  )
  it("dateInput parent div should have class date", ->
    expect($(element).find('.input-group').hasClass('date')).toBeTruthy()
  )
  it("dateInput input should have class ng-pristine", ->
    expect($(element).find('input').hasClass('ng-pristine')).toBeTruthy()
  )

  describe('DateInput on input', ->
    beforeEach(
      () ->
        $(element).find('input').val("18/10/1977")
        $(element).find('input').trigger("change")
    )

    it("should be dirty", ->
      expect($(element).find('input').hasClass('ng-pristine')).toBeFalsy()
      expect($(element).find('input').hasClass('ng-dirty')).toBeTruthy()
    )
  )

  describe('DateInput on empty input', ->
    beforeEach(
      () ->
        $(element).find('input').val(" ")
        $(element).find('input').trigger("change")
        scope.$digest()
    )

    it("should be dirty", ->
      expect($(element).find('input').hasClass('ng-pristine')).toBeFalsy()
      expect($(element).find('input').hasClass('ng-dirty')).toBeTruthy()
    )

    it("should be invalid", ->
      expect($(element).find('input').hasClass('ng-invalid-required')).toBeTruthy()
    )
  )

  describe('DateInput multidate', ->
    beforeEach(
      () ->
        $(element).find('input').attr('multidate', 'true')
        scope.$digest()
    )

    it("should be dirty", ->
      expect($(element).find('input').attr('multidate')).toBe 'true'
    )

  )
)
