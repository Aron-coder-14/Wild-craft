screenWidth, screenHeight = love.graphics.getDimensions()

-- Make GameStates global
GameStates = {
    SIMULATOR = require "simulator.simulator",

    DEATH = require "Death.Death"
}

currentGameState = GameStates.SIMULATOR

function love.load()
    -- Loop through all game states and call their load function if it exists
    for _, gameState in pairs(GameStates) do
        if gameState.load then  -- Check if the game state has a load function
            gameState.load()
        end
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