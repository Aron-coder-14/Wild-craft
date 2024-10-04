-- simulator.lua
local Camera = require "libraries.hump.camera"
local Simulator = {}
local player_x = screenWidth / 2
local player_y = screenHeight / 1.75
local character_image_path = "assets/sprites/character_1.png"
local character_image
local is_going_left = false
local flip_horizontal = 1
local background_image_path = "assets/landscape/background.png"
local background_image
local camera
local scaler = require 'utils.graphics.scaler'
local infiniteBackground = require 'utils.graphics.infiniteBackground'
local bg_scale_width, bg_scale_height
local character_desired_height = screenHeight / 20
local character_width_scale, character_height_scale, character_current_width, character_current_height

function Simulator.load()
    character_image = love.graphics.newImage(character_image_path)
    background_image = love.graphics.newImage(background_image_path)
    camera = Camera(player_x, player_y)

    local bg_height = background_image:getHeight()
    local bg_original_width = background_image:getWidth()
    bg_scale_width, bg_scale_height = scaler.backgroundscaler(bg_original_width, bg_height)

    character_current_width, character_current_height = character_image:getDimensions()
    character_width_scale, character_height_scale = scaler.aspect_ratio_scaler_by_height(character_current_width, character_current_height, character_desired_height)

    local zoomFactor = (screenHeight / (character_current_height * character_height_scale)) / 9
    camera:zoom(zoomFactor)

    -- Initialize the infiniteBackground module
    infiniteBackground.initialize(background_image, bg_scale_width, screenWidth)

    camera:lookAt(player_x, player_y)
end

function Simulator.update(dt)
    if love.keyboard.isDown("right", "d") then
        is_going_left = false
        player_x = player_x + 200 * dt
    end
    if love.keyboard.isDown("left", "a") then
        is_going_left = true
        player_x = player_x - 200 * dt
    end

    flip_horizontal = is_going_left and -1 or 1

    camera:lookAt(player_x, player_y)

    -- Update the infiniteBackground based on the player's position
    infiniteBackground.update(player_x)
end

function Simulator.draw()
    camera:attach()

    -- Draw active backgrounds
    local activeBackgrounds = infiniteBackground.getActiveBackgrounds()
    for _, bg in ipairs(activeBackgrounds) do
        if bg.mirrored then
            -- Draw mirrored background
            love.graphics.draw(background_image, bg.x + background_image:getWidth() * bg_scale_width, 0, 0, -bg_scale_width, bg_scale_height)
        else
            -- Draw normal background
            love.graphics.draw(background_image, bg.x, 0, 0, bg_scale_width, bg_scale_height)
        end
    end

    -- Draw the character
    local character_draw_x = player_x - (character_current_width * character_width_scale / 2)
    local character_draw_y = player_y - (character_current_height * character_height_scale / 2)
    love.graphics.draw(character_image, character_draw_x, character_draw_y, 0, flip_horizontal * character_width_scale, character_height_scale)

    camera:detach()
end

return Simulator