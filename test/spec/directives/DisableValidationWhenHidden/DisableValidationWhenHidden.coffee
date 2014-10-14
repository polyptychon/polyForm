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

)
