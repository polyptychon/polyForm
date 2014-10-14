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

  compileElement = (options) ->
    element = $("<div></div>").html(template({ options: options }))
    $compile(element)(scope)
    scope.$digest()

  beforeEach(angular.mock.module("myApp"))

  beforeEach(inject((_$rootScope_, _$compile_) ->
    $rootScope = _$rootScope_
    $compile = _$compile_
    scope = $rootScope
  ))

  describe('default attributes', ->
    beforeEach(
      ()->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput'})
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
  describe('attribute multidate', ->
    it("should be true when set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', multidate: 'true'})
      expect($(element).find('.input-group.date').attr('multidate')).toBe 'true'
    )
    it("should be undefined when is not set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', multidate: null})
      expect($(element).find('.input-group.date').attr('multidate')).toBeUndefined()
    )
  )

  describe('attribute force-parse', ->
    it("should be true when set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', forceParse: 'true'})
      expect($(element).find('.input-group.date').attr('force-parse')).toBe 'true'
    )
    it("should be undefined when is not set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', forceParse: null})
      expect($(element).find('.input-group.date').attr('force-parse')).toBeUndefined()
    )
  )

  describe('attribute clear-btn', ->
    it("should be true when set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', clearBtn: 'true'})
      expect($(element).find('.input-group.date').attr('clear-btn')).toBe 'true'
    )
    it("should be undefined when is not set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', clearBtn: null})
      expect($(element).find('.input-group.date').attr('clear-btn')).toBeUndefined()
    )
  )

  describe('attribute today-highlight', ->
    it("should be true when set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', todayHighlight: 'true'})
      expect($(element).find('.input-group.date').attr('today-highlight')).toBe 'true'
    )
    it("should be undefined when is not set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', todayHighlight: null})
      expect($(element).find('.input-group.date').attr('today-highlight')).toBeUndefined()
    )
  )

  describe('attribute autoclose', ->
    it("should be true when set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', autoclose: 'true'})
      expect($(element).find('.input-group.date').attr('autoclose')).toBe 'true'
    )
    it("should be undefined when is not set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', autoclose: null})
      expect($(element).find('.input-group.date').attr('autoclose')).toBeUndefined()
    )
  )

  describe('attribute multidate-separator', ->
    it("should be true when set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', multidateSeperator: ':'})
      expect($(element).find('.input-group.date').attr('multidate-separator')).toBe ':'
    )
    it("should be undefined when is not set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', multidateSeperator: null})
      expect($(element).find('.input-group.date').attr('multidate-separator')).toBeUndefined()
    )
  )

  describe('attribute format', ->
    it("should be true when set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', format: 'mm/dd/yyyy'})
      expect($(element).find('.input-group.date').attr('format')).toBe 'mm/dd/yyyy'
    )
  )

  describe('attribute language', ->
    it("should be true when set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', language: 'en'})
      expect($(element).find('.input-group.date').attr('language')).toBe 'en'
    )
    it("should be true when set", ->
      compileElement({name:'dateInput',label:'dateInput',type:'dateInput', language: null})
      expect($(element).find('.input-group.date').attr('language')).toBeUndefined()
    )
  )
)
