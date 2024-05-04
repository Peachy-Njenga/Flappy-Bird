Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60

--initialize the pipe
function Pipe:init()
    --intitalize the pipe on the right edge of the screen
    self.x = VIRTUAL_WIDTH

    self.y = math.random(VIRTUAL_HEIGHT /4, VIRTUAL_HEIGHT - 10)

    self.width = PIPE_IMAGE:getWidth()

end

--pipe should move
function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
    
end    

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end