screenWidth, screenHeight = love.graphics.getDimensions()
love = require 'love'
-- Make GameStates global
GameStates = {
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