--Import the push library for virtual resolution
push = require 'push'

--Physical screen dimensions
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 700

--Virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--images to be loaded onto the background 
-- background image and the position at which it will start scrolling
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

--ground scrolling start position
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

--speed at which images with scrolling(constants)
local BACKGROUND_SCROLL_SPEED = 20 
local GROUND_SCROLL_SPEED = 60

--point at which the background with loop back: start the scroll again- for continuity 
local BACKGROUND_LOOPING_POINT = 413 

function love.load()
    --nearest neighbour filter for the retro vibe :)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --app window title
    love.window.setTitle('Flappy Birdy')

    --initializa the virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })
end

--for the resize feature from push
-- function love.resize(w, h)
--     push:resize(w, h)
-- end

--Closing the application:
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    --scroll the background to move with speed: speed * dt, loops back to 0
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    --scroll the ground to move with speed: speed * dt, loops back to 0, after screen width is passed
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH

end

--rendering 
function love.draw()
    push:start()

    --draw the mountains from the top left
    --draw the images shifted to the left by their looping point. They will scroll, eventually reaching 0 
    --and the looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    --draw the ground from bottom left
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end




