screenWidth, screenHeight = love.graphics.getDimensions()
love = require 'love'
-- Make GameStates global
GameStates = {
    DEV_MENU = 'GUI.devMscreenWidth, screenHeight = love.window.getDesktopDimensions()enu',
    HUB = "hub",
    PLATFORMER = "platformer",
    ACTION = "action",
    STRATEGY = "strategy",
    SPORTS = "sports",
    FIGHTING = "fighting",
    SHOOTING = "shooting",
    RACING = "racing",
    SIDE_SCROLLING_BEAT_EM_UP = "side_scrolling_beat_em_up",
    STEALTH = "stealth",
    RHYTHM = "rhythm",
    EDUCATIONAL = "educational",
    ARTILLERY = "artillery",
    BEAT_EM_UP = "beat_em_up",
    INTERACTIVE_FICTION = "interactive_fiction",
    SIMULATOR = require "simulator.simulator",
}

currentGameState = GameStates.SIMULATOR

function love.load()
    if currentGameState.load then
        currentGameState.load()
    end
end

function love.update(dt)
    if currentGameState.update then
        currentGameState.update(dt)
    end
end

function love.mousepressed(x, y, button)
    if currentGameState.mousepressed then
        currentGameState.mousepressed(x, y, button)
    end
end

function love.draw()
    if currentGameState.draw then
        currentGameState.draw()
    end
end

function love.keypressed(key)
    if currentGameState.keypressed then
        currentGameState.keypressed(key)
    end
end

function love.textedited(text, start, length)
    if currentGameState.textedited then
        currentGameState.textedited(text, start, length)
    end
end

function love.textinput(t)
    if currentGameState.textinput then
        currentGameState.textinput(t)
    end
end