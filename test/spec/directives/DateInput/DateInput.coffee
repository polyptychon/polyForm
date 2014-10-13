require "../../../../_src/coffee/main.coffee"

require "angular-mocks/angular-mocks"
template = require "./date-input-example.jade"

describe('DateInput', ->
  angular.module('myApp', ['PolyForm'])


  $compile = null
  $rootScope = null
  element = null
  scope = null
  formControlElement = null

  beforeEach(angular.mock.module("myApp"))

  beforeEach(inject((_$rootScope_, _$compile_) ->
    $rootScope = _$rootScope_
    $compile = _$compile_
    scope = $rootScope

    element = $("<div></div>").html(template())
    element.css('display', 'block')

    $compile(element)(scope)
    scope.$digest()

    formControlElement = $(element).find('.has-feedback')
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

  describe('DateInput on valid input', ->
    beforeEach(
      () ->
        $(element).find('input').val("18/10/1977")
        $(element).find('input').trigger("change")
    )

    it("should be dirty", ->
      expect($(element).find('input').hasClass('ng-pristine')).toBeFalsy()
      expect($(element).find('input').hasClass('ng-dirty')).toBeTruthy()
    )
    describe('formControl', ->
      it("should have the same classes", ->
        expect(formControlElement.hasClass('ng-valid')).toBeTruthy()
        expect(formControlElement.hasClass('ng-valid-required')).toBeTruthy()
        expect(formControlElement.hasClass('has-success')).toBeTruthy()
      )
    )
    describe('form', ->
      it("should be valid", ->
        expect(element.scope().testForm.$valid).toBeTruthy()
      )
    )
  )

  describe('DateInput on invalid input', ->
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
    describe('formControl', ->
      it("should have the same classes", ->
        expect(formControlElement.hasClass('ng-valid')).toBeFalsy()
        expect(formControlElement.hasClass('ng-valid-required')).toBeFalsy()
        expect(formControlElement.hasClass('ng-invalid-required')).toBeTruthy()
        expect(formControlElement.hasClass('has-success')).toBeFalsy()
        expect(formControlElement.hasClass('has-error')).toBeTruthy()
      )
    )
    describe('form', ->
      it("should be invalid", ->
        expect(element.scope().testForm.$valid).toBeFalsy()
      )
    )
  )
)
