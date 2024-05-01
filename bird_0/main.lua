--Import the push library for virtual resolution
push = require 'push'

--Physical screen dimensions
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 700

--Virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--iamges to be loaded onto the background 
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

function love.load()
    --nearest neighbour filter for the retro vibe :)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --app window title
    love.window.setTitle('Flapp Bird')

    --initializa the virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })
end

--for the resize feature form push
-- function love.resize(w, h)
--     push:resize(w, h)
-- end

--Closing the application:
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

--rendering 
function love.draw()
    push:start()

    --draw the mountains from the top left
    love.graphics.draw(background, 0, 0)

    --draw the ground from bottom left
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    push:finish()
end




