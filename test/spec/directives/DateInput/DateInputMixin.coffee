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

  describe('validation attributes', ->
    describe('ng-required', ->
      it("should have attribute ng-required with value true", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput', ngRequired: 'true'})
        expect($(element).find('input').attr('ng-required')).toBe 'true'
      )
      it("should not have attribute ng-required", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput', ngRequired: 'false'})
        expect($(element).find('input').attr('ng-required')).toBeUndefined()
      )
    )
    describe('ng-minlength', ->
      it("should have attibute ng-minlength with value 3", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput', ngMinlength: 3})
        expect($(element).find('input').attr('ng-minlength')).toBe '3'
      )
      it("should not have attibute ng-minlength", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput'})
        expect($(element).find('input').attr('ng-minlength')).toBeUndefined()
      )
    )
    describe('ng-maxlength', ->
      it("should have attibute ng-maxlength with value 3", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput', ngMaxlength: 3})
        expect($(element).find('input').attr('ng-maxlength')).toBe '3'
      )
      it("should not have attibute ng-maxlength", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput'})
        expect($(element).find('input').attr('ng-maxlength')).toBeUndefined()
      )
    )
    describe('ng-pattern', ->
      it("should have attribute ng-pattern with value /((?=.*[a-z])(?=.*[A-Z]).{8,64})/", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput', ngPattern: "/((?=.*[a-z])(?=.*[A-Z]).{8,64})/"})
        expect($(element).find('input').attr('ng-pattern')).toBe '/((?=.*[a-z])(?=.*[A-Z]).{8,64})/'
      )
      it("should not have attibute ng-pattern", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput'})
        expect($(element).find('input').attr('ng-pattern')).toBeUndefined()
      )
    )

    describe('ui-validate', ->
      it("should have attribute ui-validate with $value=test", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput', uiValidate: "'$value==test'"})
        expect($(element).find('input').attr('ui-validate')).toBe "'$value==test'"
      )
      it("should not have attibute ui-validate", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput'})
        expect($(element).find('input').attr('ui-validate')).toBeUndefined()
      )
    )
    describe('ui-validate-watch', ->
      it("should have attribute ui-validate-watch with test", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput', uiValidateWatch: "'test'"})
        expect($(element).find('input').attr('ui-validate-watch')).toBe "'test'"
      )
      it("should not have attibute ui-validate-watch", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput'})
        expect($(element).find('input').attr('ui-validate-watch')).toBeUndefined()
      )
    )
    describe('is-unique', ->
      it("should have attribute is-unique with value test.json", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput', isUnique: "test.json"})
        expect($(element).find('input').attr('is-unique')).toBe "test.json"
      )
      it("should not have attibute is-unique", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput'})
        expect($(element).find('input').attr('is-unique')).toBeUndefined()
      )
    )
    describe('is-unique-map-data', ->
      it("should have attribute is-unique-map-data with value {test:'true'}", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput', mapData: "{test:'true'}"})
        expect($(element).find('input').attr('is-unique-map-data')).toBe "{test:'true'}"
      )
      it("should not have attibute is-unique", ->
        compileElement({name:'dateInput',label:'dateInput',type:'dateInput'})
        expect($(element).find('input').attr('is-unique-map-data')).toBeUndefined()
      )
    )
  )
)
