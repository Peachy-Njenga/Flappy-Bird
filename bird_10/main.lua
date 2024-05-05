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

--import states in use
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountdownState'


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

    --intialze the fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    --initializa the virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --initialize state machine with all state-returning functions*
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function () return ScoreState() end
    }

    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

--for the resize feature from push
function love.resize(w, h)
    push:resize(w, h)
end

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
        % GROUND_LOOPING_POINT

    gStateMachine:update(dt)

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

    gStateMachine:render()

    --draw the ground from bottom left
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)


    push:finish()
end
