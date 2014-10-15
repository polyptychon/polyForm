require "../../../../_src/coffee/main.coffee"
require "angular-mocks/angular-mocks"
compileTemplate = require "../../utils/compileTemplate.coffee"
waitForNextFrame = require "../../utils/waitForNextFrame.coffee"
template = require "./example.jade"

describe('FormTab', ->
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

    compileElement({name:'test',label:'test',type:'text',model:'testForm.testModel'})
    formControlElement = $(element).find('.has-feedback')
  ))

  it("should have 3 input controls", ->
    expect($(element).find('input').length).toBe 3
  )

  it("should have 2 tabs", ->
    expect($(element).find('#formTablist > li').length).toBe 2
    expect($(element).find('.tab-pane').length).toBe 2
  )

  it("should have second tab disabled", ->
    expect($(element).find('#formTablist > li').eq(1).hasClass("disabled")).toBeTruthy()
  )
  it("should have next button disabled", ->
    expect($(element).find('[ng-click="selectNextPane()"]').attr("disabled")).toBe 'disabled'
  )
  it("should have second tab inputs disabled", ->
    secondTabInputs = $(element).find('#formTablist > li').eq(1).find("input")
    secondTabInputs.each(()->
      expect($(@).attr("disabled")).toBe 'disabled'
    )
  )
  describe('When First tab inputs is valid', ->
    beforeEach(()->
      showNextTabCheckbox = $(element).find('[name="showNextTabCheckbox"]')
      showNextTabCheckbox.trigger('click') unless showNextTabCheckbox.attr('checked')?

      firstTabInput = $(element).find('[name="maxlength"]')
      firstTabInput.val("a")
      firstTabInput.trigger("change")
    )

    it("should have second tab enabled", ->
      expect($(element).find('#formTablist > li').eq(1).hasClass("disabled")).toBeFalsy()
    )
    it("should have next button enabled", ->
      waitForNextFrame()
      runs(()->
        expect($(element).find('[ng-click="selectNextPane()"]').attr("disabled")).toBeUndefined()
      )
    )
  )
  describe('When First tab showNextTabCheckbox is not checked (second tab is removed)', ->
    beforeEach(()->
      showNextTabCheckbox = $(element).find('[name="showNextTabCheckbox"]')
      showNextTabCheckbox.trigger('click') unless showNextTabCheckbox.attr('checked')?
    )
    it("should have second tab enabled", ->
      expect($(element).find('#formTablist > li').length).toBe 1
      secondTabInputs = $(element).find('#formTablist > li').eq(1).find("input")
      secondTabInputs.each(()->
        expect($(@).attr("disabled")).toBe 'disabled'
      )
    )
  )
)
