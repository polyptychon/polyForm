$ = require "jquery"

require "angular/angular"
require "angular-mocks/angular-mocks"
GameCTR   = require "../../../_src/coffee/controllers/GameCTR.coffee"
GameData  = require "../../../_src/coffee/factories/GameDataFactory.coffee"
Map       = require "../../../_src/coffee/directives/Map.coffee"
template  = require("../../../_src/templates/partials/map.jade")

describe('Map', ->

  angular.module('myApp', [])
    .directive('map', ['$parse', Map])

  $compile = null
  $rootScope = null
  element = null
  scope = null

  beforeEach(angular.mock.module("myApp"))

  beforeEach(inject((_$rootScope_, _$compile_) ->
    $rootScope = _$rootScope_
    $compile = _$compile_
    scope = $rootScope

    new GameCTR(scope, null, new GameData() )

    element = $("<div></div>").html(template())

    $compile(element)(scope)
    scope.$digest()
  ))

  it("map should have the correct amount of Questions in SVG", ->
    expect($(element).find('g[question="true"]').length).toBe scope.questions.length
  )
  it("map should not have element with attribute selected", ->
    selectedElement = $(element).find('[selected="selected"]')
    expect(selectedElement.length).toBe 0
  )
  describe("if a question is selected", ->
    selectedElement = null
    beforeEach(->
      scope.selectedQuestion = scope.questions[0]
      scope.$apply()
      selectedElement = $(element).find("\##{scope.selectedQuestion.name}")
    )
    it("map question should have attribute selected", ->
      expect(selectedElement.attr("selected")).toBe "selected"
    )
    it("selected map question should be only one", ->
      expect(selectedElement.length).toBe 1
    )
  )
  describe("if a question is answered", ->
    beforeEach(->
      question = scope.questions[0]
      scope.answerQuestion( question, question.answer, true )
      scope.$apply()
    )
    it("map question should have attribute final value true", ->
      selectedElements = $(element).find('[final="true"]')
      expect(selectedElements.length).toBe(1)
    )
  )
  describe("if questions are answered", ->
    beforeEach(->
      question = scope.questions[0]
      scope.answerQuestion( question, question.answer, true )
      question = scope.questions[1]
      scope.answerQuestion( question, question.answer, true )
      scope.$apply()
    )
    it("answered map questions should have attribute final value true", ->
      selectedElements = $(element).find('[final="true"]')
      expect(selectedElements.length).toBe scope.getAnsweredQuestions().length
    )
  )
#  describe("if a map element is clicked", ->
#    question = null
#    beforeEach(->
#      question = scope.questions[0]
#      $(element).find("\##{question.name} path").click()
#    )
#    it("should select a question", ->
#      expect(scope.selectedQuestion).toBeTruthy()
#    )
#    it("should select the correct question", ->
#      expect(scope.selectedQuestion.name).toBe $(element).find("\##{question.name}").attr("id")
#    )
#  )
)