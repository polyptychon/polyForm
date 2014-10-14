require "../../../../_src/coffee/main.coffee"
require "angular-mocks/angular-mocks"
compileTemplate = require "../../utils/compileTemplate.coffee"
template = require "./example.jade"

describe('DisableValidationWhenHidden', ->
  angular.module('myApp', ['PolyForm'])


  $compile = null
  $rootScope = null
  element = null
  scope = null
  formControlElement = null

  compileElement = (options) ->
    element = compileTemplate(options, scope, $compile, template)

  beforeEach(angular.mock.module("myApp"))

  beforeEach(inject((_$rootScope_, _$compile_) ->
    $rootScope = _$rootScope_
    $compile = _$compile_
    scope = $rootScope

    compileElement({name:'dateInput',label:'dateInput',type:'dateInput'})
    formControlElement = $(element).find('.has-feedback')
  ))

  it("should have attribute disable-validation-when-hidden", ->
    expect($(element).find('[disable-validation-when-hidden]').length).toBe 1
  )
  describe('when false', ->
    beforeEach(
      ()->
        hideCheckbox = $(element).find('[name="hideCheckbox"]')
        hideCheckbox.trigger('click') if hideCheckbox.attr('checked')?
    )
    it("should show element", ->
      expect($(element).find('[disable-validation-when-hidden]').hasClass('ng-hide')).toBeFalsy()
    )
    it("should have next button enable", ->
      expect($(element).find('[ng-click="selectNextPane()"]').attr('disabled')).toBe "disabled"
    )
    it("should have child inputs enabled", ->
      $(element).find('[disable-validation-when-hidden]').find("input").each(
        () ->
          expect($(@).attr('disabled')).toBeUndefined()
      )
    )
  )

  describe('when true', ->
    beforeEach(
      ()->
        hideCheckbox = $(element).find('[name="hideCheckbox"]')
        hideCheckbox.trigger('click') unless hideCheckbox.attr('checked')?
    )
    it("should show element", ->
      expect($(element).find('[disable-validation-when-hidden]').hasClass('ng-hide')).toBeTruthy()
    )
    it("should have next button enable", ->
      expect($(element).find('[ng-click="selectNextPane()"]').attr('disabled')).toBe "disabled"
    )
    it("should have child inputs enabled", ->
      $(element).find('[disable-validation-when-hidden]').find("input").each(
        () ->
          expect($(@).attr('disabled')).toBe 'disabled'
      )
    )
  )

)
