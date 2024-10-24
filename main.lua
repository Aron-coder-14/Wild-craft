screenWidth, screenHeight = love.graphics.getDimensions()

-- Make GameStates global
GameStates = {
    SIMULATOR = require "simulator.simulator",

    DEATH = require "Death.Death"
}
floorY = screenHeight / 1.65
 player = {
    image_path = "assets/sprites/character_1.png",
    desired_height = screenHeight / 20,
    width_scale = 1,
    height_scale = 1,
    current_width = 50,
    current_height = 50,
    x = screenWidth / 2,
    y = floorY - 50,  -- Start just above the floor
    width = 50,
    height = 50,
    speedY = 0,  -- Vertical speed (gravity)
    gravity = 800,  -- Gravity force (pixels per second^2)
    jumpForce = -275,  -- Force applied when jumping
    speedX = 0,  -- Horizontal speed (used only in air)
    maxSpeedX = 300,  -- Maximum horizontal speed
    currentSpeedX = 0, -- Current horizontal speed
    acceleration = 1000,  -- Horizontal acceleration
    deceleration = 500,  -- Deceleration when no input is given
    onGround = false,  -- Check if the player is on the ground
    health = 50,
    default_health = 50,  -- Add default health
    is_dead = false 
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