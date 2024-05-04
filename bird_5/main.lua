--Import the push library for virtual resolution
push = require 'push'

--import class library for OOP
Class = require('class')

--import our bird class
require 'Bird'

--import the pipe class
require 'Pipe'

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

--the bird sprite
local bird = Bird()

--the pipes
local pipes = {}

local spawnTimer = 0

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
    --scroll the background to move with speed: speed * dt, loops back to 0
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    --scroll the ground to move with speed: speed * dt, loops back to 0, after screen width is passed
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH

    --timer for spawning the pipes
    spawnTimer = spawnTimer + dt

    --spawns a pipe every 2s and adds it to the pipes table
    if spawnTimer > 2 then
        table.insert(pipes, Pipe())
        spawnTimer = 0
    end

    bird:update(dt)

    --iterate over the pipes table
    for k, pipe in pairs(pipes) do
        --scroll each pipe
        pipe:update(dt)

        --delete each pipe after it passes the left edge of the screen
        if pipe.x < -pipe.width then
            table.remove(pipes, k)
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
    for k, pipe in pairs(pipes) do 
        pipe:render()
    end

    --draw the ground from bottom left
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    --render the bird onto the screem
    bird:render()

    push:finish()
end
