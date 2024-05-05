Bird = Class{}

local GRAVITY = 10

function Bird:init()
    --load the bird image and give it a width and height
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --the bird is in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT /2 - (self.height / 2)

    self.dy = 0
end

--collision detection 
function Bird:collides(pipe)
    --****** with leeway for  the  user
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false

end

--gravity update: making the birdie fall :(
function Bird:update(dt)
    --velocity of the bird with gravity applied
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -3
        sounds['jump']:play()
    end

    --apply this velocity to the y position of the bird
    self.y = self.y + self.dy
end

--Render the bird
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end


