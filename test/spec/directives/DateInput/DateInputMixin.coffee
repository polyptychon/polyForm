require "../../../../_src/coffee/main.coffee"
require "angular-mocks/angular-mocks"
template = require "./date-input-example.jade"

describe('DateInput mixin', ->
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
  ))

  describe('default attributes', ->
    beforeEach(
      ()->
        element = $("<div></div>").html(template({
          options: {name:'dateInput',label:'dateInput',type:'dateInput'}
        }))
        $compile(element)(scope)
        scope.$digest()
    )
    describe('Element with class .input-group.date', ->
      it("should have element", ->
        expect($(element).find('.input-group.date').length).toBe 1
      )
      it("attribute format default value", ->
        expect($(element).find('.input-group.date').attr('format')).toBe 'dd/mm/yyyy'
      )
    )
    describe('input', ->
      it("should have attr type dateInput", ->
        expect($(element).find('input').attr('type')).toBe 'dateInput'
      )
      it("should have attr ng-required", ->
        expect($(element).find('input').attr('ng-required')).toBe 'true'
      )
    )
  )
  describe('default attribute multidate', ->
    it("should be true when set", ->
      element = $("<div></div>").html(template({
        options: {name:'dateInput',label:'dateInput',type:'dateInput', multidate: 'true'}
      }))
      $compile(element)(scope)
      scope.$digest()
      expect($(element).find('.input-group.date').attr('multidate')).toBe 'true'
    )
    it("should be undefined when is not set", ->
      element = $("<div></div>").html(template({
        options: {name:'dateInput',label:'dateInput',type:'dateInput', multidate: null}
      }))
      $compile(element)(scope)
      scope.$digest()
      expect($(element).find('.input-group.date').attr('multidate')).toBeUndefined()
    )
  )

)
