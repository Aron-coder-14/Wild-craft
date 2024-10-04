-- simulator.lua
local Camera = require "libraries.hump.camera" -- Include HUMP Camera
local Simulator = {}

local width = 200
local height = 200
local player_x = screenWidth / 2 - width / 2
local player_y = screenHeight / 2 - height / 2
local character_image_path = "assets/sprites/character_1.png"
local character_image
local is_going_left = false
local flip_horizontal = 1 -- Default to not flipped (1 means normal scale)
local background_image_path = "assets/landscape/background.png"
local background_image
local camera -- Declare the camera
local scaler = require 'utils.graphics.scaler'
local bg_scale_width
local bg_scale_height
local bg_height
local bg_width
local character_desired_height=screenHeight/20
local character_width_scale, character_height_scale, character_current_width, character_current_height
function Simulator.load()
    character_image = love.graphics.newImage(character_image_path)
    background_image = love.graphics.newImage(background_image_path)
    camera = Camera(player_x, player_y)

    bg_height = background_image:getHeight()
    bg_width = background_image:getWidth()
    bg_scale_width, bg_scale_height = scaler.backgroundscaler(bg_width, bg_height)

    character_current_width, character_current_height = character_image:getDimensions()
    character_width_scale, character_height_scale = scaler.aspect_ratio_scaler_by_height(character_current_width, character_current_height, character_desired_height)

    -- Calculate zoom factor based on the character's height relative to the screen
    local zoomFactor = screenHeight / (character_current_height * character_height_scale * 2)
    camera:zoom(zoomFactor)  -- Apply zoom based on character size

    -- Center the camera on the player's starting position
    camera:lookAt(player_x, player_y)
end

function Simulator.update(dt)
    -- Player movement logic
    if love.keyboard.isDown("right") then
        is_going_left = false
        player_x = player_x + 200 * dt
    end
    if love.keyboard.isDown("left") then
        is_going_left = true
        player_x = player_x - 200 * dt
    end
    if love.keyboard.isDown("down") then
        player_y = player_y + 200 * dt
    end
    if love.keyboard.isDown("up") then
        player_y = player_y - 200 * dt
    end

    -- Flip the character if going left or right
    if is_going_left then
        flip_horizontal = -1 -- Flip the character when moving left
    else
        flip_horizontal = 1 -- Reset flip when moving right
    end

    -- Center the camera on the player after moving and zooming
    camera:lookAt(player_x, player_y)
end

function Simulator.draw()
    camera:attach() -- Attach the camera for all drawings
    -- Draw the background and character
    love.graphics.draw(background_image, 0, 0, 0, bg_scale_width, bg_scale_height)
    
    -- Draw the character with scaling
    love.graphics.draw(character_image, player_x, player_y, 0, flip_horizontal * character_width_scale, character_height_scale)
    
    camera:detach() -- Detach the camera after drawing
end

return Simulator
