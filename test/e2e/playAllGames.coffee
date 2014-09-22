ptor = protractor.getInstance()
scorePanel = null
gameResultsAnswers = null


describe("Play Games", ->
  beforeEach( ->
    browser.driver.manage().window().setSize(1024, 768)
    browser.get("game.html")

    questions = element.all(By.css('.questions li'))
    questionPanel = element(By.css('.sidebar-question-panel'))
    scorePanel = element(By.css('.score-panel'))
    gameResultsAnswers = element(By.css('.score-panel .answers'))
    questions.first().click()

    questions.each( ()->
      answers = questionPanel.all(By.css('.answers li a'))
      nextButton = element(By.css('.next-question'))

      answer = answers.get(0)
      answer.click()
      nextButton.isDisplayed()
        .then( (value)->
          nextButton.click() if (value)
        )

    )
    scorePanel.isDisplayed().then( (value)->
      if (value)
        actions = scorePanel.all(By.css("a"))
        actions.last().click()
    )

    questions = element.all(By.css('.questions li'))

    questions.each( ()->
      answers = questionPanel.all(By.css('.answers li a'))
      nextButton = element(By.css('.next-question'))

      answer = answers.get(0)
      answer.click()
      nextButton.isDisplayed()
      .then( (value)->
        nextButton.click() if (value)
      )

    )

    scorePanel.isDisplayed().then( (value)->
      if (value)
        actions = scorePanel.all(By.css("a"))
        actions.last().click()
    )

    questions = element.all(By.css('.questions li'))

    questions.each( ()->
      answers = questionPanel.all(By.css('.answers li a'))
      nextButton = element(By.css('.next-question'))

      answer = answers.get(0)
      answer.click()
      nextButton.isDisplayed()
      .then( (value)->
        nextButton.click() if (value)
      )

    )

    ptor.sleep(2000)
  )

  it('should show results', ->
    expect(scorePanel.isDisplayed()).toBeTruthy()
    expect(gameResultsAnswers.getText()).toBe("10")
  )
)