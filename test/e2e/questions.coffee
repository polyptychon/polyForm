describe('Game', ->
  browser.get('game.html')
  browser.driver.manage().window().setSize(1024, 768)

  it('should have a title', ->
    expect(browser.getTitle()).toEqual('IONIAN GAME')
  )

  describe('questions', ->
    describe('when a question is clicked', ->
      questions = element.all(By.css('.questions li'))
      firstQuestion = questions.first()
      questionPanel = element(By.css('.sidebar-question-panel'))

      beforeEach( ->
        firstQuestion.click()
      )

      it('it should add class selected to the question', ->
        expect(firstQuestion.getAttribute('class')).toMatch(/selected/)
      )

      it('it should open questionPanel', ->
        expect(questionPanel.getAttribute('class')).toMatch(/open/)
      )

      describe('question panel', ->

        closePanelButton = element(By.css('.close-question-panel-icon'))

        it('it should be closed when closePanelButton is clicked', ->
          closePanelButton.click()
          expect(questionPanel.getAttribute('class')).toNotMatch(/open/)
        )

        describe('answers', ->
          answers = questionPanel.all(By.css('.answers li a'))
          firstAnswer = answers.first()

          it('it should select first answer when clicked', ->
            firstAnswer.click()
            expect(firstAnswer.getAttribute("class")).toMatch(/selected/)
          )
        )

      )
    )
  )
)

