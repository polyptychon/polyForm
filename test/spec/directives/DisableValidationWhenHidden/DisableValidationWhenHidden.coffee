require "../../../../_src/coffee/main.coffee"
require "angular-mocks/angular-mocks"
requestAnimFrame = require "animationframe"
compileTemplate = require "../../utils/compileTemplate.coffee"
waitForNextFrame = require "../../utils/waitForNextFrame.coffee"
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
    it("should have next button disabled", ->
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
    describe('when form is invalid', ->

      it("should show element", ->
        expect($(element).find('[disable-validation-when-hidden]').hasClass('ng-hide')).toBeTruthy()
      )
      it("should have next button disabled on next frame", ()->
        waitForNextFrame()
        runs(() ->
          nextButton =  $(element).find('[ng-click="selectNextPane()"]').first()
          expect(nextButton.attr('disabled')).toBe "disabled"
        )
      )
      it("should have submit button disabled on next frame", ()->
        waitForNextFrame()
        runs(() ->
          submitButton =  $(element).find('button[ng-disabled="myform4.$invalid"]').first()
          expect(submitButton.attr('disabled')).toBe "disabled"
        )
      )
      it("should have child inputs enabled", ->
        $(element).find('[disable-validation-when-hidden]').find("input").each(
          () ->
            expect($(@).attr('disabled')).toBe 'disabled'
        )
      )
    )
    describe('when form is valid', ->
      beforeEach(
        (done)->
          $(element).find('[name="maxlength"]').val("a")
          $(element).find('[name="maxlength"]').trigger("change")
      )
      it("should show element", ()->
        expect($(element).find('[disable-validation-when-hidden]').hasClass('ng-hide')).toBeTruthy()
      )
      it("should have next button enable on next frame", ()->
        waitForNextFrame()
        runs(() ->
          nextButton =  $(element).find('[ng-click="selectNextPane()"]').first()
          expect(nextButton.attr('disabled')).toBeUndefined()
        )
      )
      it("should have submit button enable on next frame", ()->
        waitForNextFrame()
        runs(() ->
          submitButton =  $(element).find('button[ng-disabled="myform4.$invalid"]').first()
          expect(submitButton.attr('disabled')).toBeUndefined()
        )
      )
      it("should have child inputs enabled", ()->
        $(element).find('[disable-validation-when-hidden]').find("input").each(
          () ->
            expect($(@).attr('disabled')).toBe 'disabled'
        )
      )
    )
  )

)
