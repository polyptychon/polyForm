ptor = protractor.getInstance()
scorePanel = null
gameResultsAnswers = null

games = [
  {
    url: "/el"
    values : [9,7,12]
  }
  {
    url: "/en"
    values : [9,7,12]
  }
  {
    url: "/el/ionio"
    values : [10,10,10]
  }
  {
    url: "/en/ionio"
    values : [10,10,10]
  }
  {
    url: "/el/europe"
    values : [10,7,11]
  }
  {
    url: "/en/europe"
    values : [10,7,11]
  }
]

games.forEach((game) ->
  game.values.forEach((value, index) ->
    describe("Play Game #{game.url}", ->
      beforeEach( ->
        browser.driver.manage().window().setSize(1024, 768)
        browser.get("game.html\##{game.url}")

        questions = element.all(By.css('.questions li'))
        questionPanel = element(By.css('.sidebar-question-panel'))
        scorePanel = element(By.css('.score-panel'))
        gameResultsAnswers = element(By.css('.score-panel .answers'))
        questions.first().click()

        questions.each( ()->

          answers = questionPanel.all(By.css('.answers li a'))
          nextButton = element(By.css('.next-question'))

          answer = answers.get(index)
          answer.click()
          nextButton.isDisplayed()
            .then( (value)->
              nextButton.click() if (value)
            )

          #ptor.sleep(2000)
        )
      )

      it('should show results', ->
        expect(scorePanel.isDisplayed()).toBeTruthy()
        expect(gameResultsAnswers.getText()).toBe(value.toString())
      )
    )

#    describe("Play Mobile Game #{game.url}", ->
#      beforeEach( ->
#        browser.driver.manage().window().setSize(384, 640) #nexus
#        #browser.driver.manage().window().setSize(320, 480) #iphone
#        #browser.driver.manage().window().setSize(320, 568) #iphone5
#        browser.get("game.html\##{game.url}")
#
#        questions = element.all(By.css('.questions li'))
#        questionPanel = element(By.css('.sidebar-question-panel'))
#        scorePanel = element(By.css('.score-panel'))
#        gameResultsAnswers = element(By.css('.score-panel .answers'))
#        questions.first().click()
#
#        questions.each( ()->
#
#          answers = questionPanel.all(By.css('.answers li a'))
#          nextButton = element(By.css('.next-question'))
#          answer = answers.get(index)
#          answer.click()
#
#          nextButton.isDisplayed()
#            .then( (value)->
#              nextButton.click() if (value)
#            )
#        )
#      )
#
#      it('should show results', ->
#        expect(scorePanel.isDisplayed()).toBeTruthy()
#        expect(gameResultsAnswers.getText()).toBe(value.toString())
#      , 300000)
#    )
  )
)