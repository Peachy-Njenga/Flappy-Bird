Bird = Class{}

function Bird:init()
    --load the bird image and give it a width and height
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --the bird is in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT /2 - (self.height / 2)
end

--Render the bird
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

