require "../../../../_src/coffee/main.coffee"
require "angular-mocks/angular-mocks"
compileTemplate = require "../../utils/compileTemplate.coffee"
waitForNextFrame = require "../../utils/waitForNextFrame.coffee"

describe('FormTab', ->
  angular.module('myApp', ['PolyForm'])


  $compile = null
  $rootScope = null
  element = null
  scope = null
  formControlElement = null
  input = null

  compileElement = (options) ->
    element = compileTemplate(options, scope, $compile)

  beforeEach(angular.mock.module("myApp"))

  beforeEach(inject((_$rootScope_, _$compile_) ->
    $rootScope = _$rootScope_
    $compile = _$compile_
    scope = $rootScope

    compileElement({name:'test',label:'test',type:'text',model:'testForm.testModel', isUnique:'http://wedding.polyptychon.gr/isUnique.json'})
    formControlElement = $(element).find('.has-feedback')
    input = $(element).find('input')
  ))

  it("should have input control", ->
    expect($(element).find('input').length).toBe 1
  )

  it("should have input attribute is-unique", ->
    expect(input.attr("is-unique")).toBeDefined()
  )

  describe('When 2 characters typed', ->
    beforeEach(() ->
      input.val("ts")
      input.trigger("change")
      scope.$digest()
    )
    it("should have class ng-loading", ->
      expect(formControlElement.hasClass("ng-loading")).toBeTruthy()
    )
    it("should have class ng-invalid-is-unique", ->
      expect(formControlElement.hasClass("ng-invalid-is-unique")).toBeTruthy()
    )
    it("should not have class ng-loading", ->
      loaded = false
      runs(() -> setTimeout( (() -> loaded = true ), 5000))
      waitsFor(()-> return loaded )

      expect(input.hasClass("ng-loading")).toBeFalsy()
      #expect(formControlElement.hasClass("ng-invalid-is-unique")).toBeFalsy()
    )
  )
)
