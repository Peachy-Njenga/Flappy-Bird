--Import the push library for virtual resolution
push = require 'push'

--import class library for OOP
Class = require('class')

--import our bird class
require 'Bird'

--import the pipe class
require 'Pipe'

--import pipe pairs
require 'PipePair'

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

--point at which the background and groundwill loop back: start the scroll again- for continuity
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

--the bird sprite
local bird = Bird()

--the pipes
local pipePairs = {}

--timer for spawning the pipes
local spawnTimer = 0

--keeping track of where th elast set of pipes was spawned
local lastY = -PIPE_HEIGHT + math.random(80) + 20

--pausing the game on collision
local scrolling = true


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

    love.keyboard.keysPressed = {}
end

--for the resize feature from push
-- function love.resize(w, h)
--     push:resize(w, h)
-- end

--Closing the application:
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if  scrolling then
        
        --scroll the background to move with speed: speed * dt, loops back to 0
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT
        
        --scroll the ground to move with speed: speed * dt, loops back to 0, after screen width is passed
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % GROUND_LOOPING_POINT
        
        --timer for spawning the pipes
        spawnTimer = spawnTimer + dt
        
        --spawns a pipe every 2s and adds it to the pipes table
        if spawnTimer > 2 then
            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            --(tbd)
            
            local y = math.max(-PIPE_HEIGHT + 10,
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = y
            
            table.insert(pipePairs, PipePair(y))
            spawnTimer = 0
        end
        
        bird:update(dt)
        
        --iterate over the pipes table
        for k, pair in pairs(pipePairs) do
            --scroll each pipe
            pair:update(dt)

            --check for collision fo reah pipe pair
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    --pause game
                    scrolling = false
                end
            end
        end
        
        -- remove any flagged pipes
        -- we need this second loop, rather than deleting in the previous loop, because
        -- modifying the table in-place without explicit keys will result in skipping the
        -- next pipe, since all implicit keys (numerical indices) are automatically shifted
        -- down after a table removal
        --also (tbd)
        for k, pair in pairs(pipePairs) do
            --delete each pipe after it passes the left edge of the screen
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end
    end

    --reset the table for the keysPressed
    love.keyboard.keysPressed = {}
end

--rendering
function love.draw()
    push:start()

    --draw the mountains from the top left
    --draw the images shifted to the left by their looping point. They will scroll, eventually reaching 0
    --and the looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    --render the pipes, render order is important
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    --draw the ground from bottom left
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    --render the bird onto the screem
    bird:render()

    push:finish()
end
