--Display player score before going back to play state

ScoreState = Class{__includes = BaseState}

--Score is received for the playstate

function ScoreState:enter(params)
    self.score = params.score    
end

function ScoreState:update(dt)
    --go back to play state when enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
    
end

function ScoreState:render()
    -- render the score in the middle of the TitleScreenState
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Game Over!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: '..tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to play again!', 0, 160, VIRTUAL_WIDTH, 'center')
end
