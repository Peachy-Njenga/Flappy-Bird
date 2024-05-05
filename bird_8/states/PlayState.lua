--bulk of the game :)

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    --last recorded y- value of pipes for placement of next pipePairs
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

end

function PlayState:update(dt)
    --update the timer for pipe spawning
    self.timer = self.timer + dt

    --spawning a new pipe
    if self.timer > 2 then
        local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        --add new pipe pair past edge of screen
        table.insert(self.pipePairs, PipePair(y))

        --reset the timer
        self.timer = 0

    end

    --for every pipe pair
    for k, pair in pairs(self.pipePairs) do
        --scroll
        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- update bird mov't
    self.bird:update(dt)

    --collision detection between bird and pipes
    for k, pair in pairs(self.pipePairs) do 
        for l,pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('title')
            end
        end
    end

    --reset if bird gets to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('title')
    end

end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    self.bird:render()    
end
