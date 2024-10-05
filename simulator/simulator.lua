-- simulator.lua
local Camera = require "libraries.hump.camera"
local Simulator = {}
local character_image_path = "assets/sprites/character_1.png"
local character_image
local is_going_left = false
local flip_horizontal = 1
local background_image_path = "assets/landscape/background.png"
local background_image
local camera
local scaler = require 'utils.graphics.scaler'
local infiniteBackground = require 'utils.graphics.infiniteBackground'
local Gravity = require 'utils.physics.gravity'
local Collisions = require 'utils.physics.collisions'
local bg_scale_width, bg_scale_height
local floorY = screenHeight / 1.65  -- This defines the floor position
local player = {
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
    jumpForce = -400,  -- Force applied when jumping
    speedX = 0,  -- Horizontal speed (used only in air)
    maxSpeedX = 300,  -- Maximum horizontal speed in air
    acceleration = 1000,  -- Horizontal acceleration in air
    deceleration = 500,  -- Deceleration in air when no input is given
    onGround = false  -- Check if the player is on the ground
}
local animatel=require'utils.graphics.animatel'

function Simulator.load()
    animatel.loadWalkingAnimation()
    player.image = love.graphics.newImage(player.image_path)
    background_image = love.graphics.newImage(background_image_path)
    camera = Camera(player.x, player.y)

    local bg_height = background_image:getHeight()
    local bg_original_width = background_image:getWidth()
    bg_scale_width, bg_scale_height = scaler.backgroundscaler(bg_original_width, bg_height)

    player.current_width, player.current_height = player.image:getDimensions()
    player.width_scale, player.height_scale = scaler.aspect_ratio_scaler_by_height(player.current_width, player.current_height, player.desired_height)

    local zoomFactor = (screenHeight / (player.current_height * player.height_scale)) / 9
    camera:zoom(zoomFactor)

    -- Initialize the infiniteBackground module
    infiniteBackground.initialize(background_image, bg_scale_width, screenWidth)

    camera:lookAt(player.x, player.y)
end

function Simulator.update(dt)
    local is_moving = false

    -- Check if the player is on the ground
    if player.onGround then
        -- Handle normal ground movement
        if love.keyboard.isDown("right", "d") then
            is_going_left = false
            player.x = player.x + player.maxSpeedX * dt
            is_moving = true
        elseif love.keyboard.isDown("left", "a") then
            is_going_left = true
            player.x = player.x - player.maxSpeedX * dt
            is_moving = true
        end
    else
         -- Handle inertia in air (jumping)
         if love.keyboard.isDown("right", "d") then
            is_going_left = false
            player.speedX = math.min(player.speedX + player.acceleration * dt, player.maxSpeedX)
        elseif love.keyboard.isDown("left", "a") then
            is_going_left = true
            player.speedX = math.max(player.speedX - player.acceleration * dt, -player.maxSpeedX)
        else
            -- Apply deceleration when no key is pressed in air
            if player.speedX > 0 then
                player.speedX = math.max(player.speedX - player.deceleration * dt, 0)
            elseif player.speedX < 0 then
                player.speedX = math.min(player.speedX + player.deceleration * dt, 0)
            end
        end

        -- Update player position with current horizontal speed (in air)
        player.x = player.x + player.speedX * dt
    end

    -- Update the animation if moving
    animatel.update(dt, is_moving)


    flip_horizontal = is_going_left and -1 or 1

    -- Apply gravity to the player
    Gravity.applyGravity(player, dt)

    -- Check for collision with the floor
    Collisions.checkFloorCollision(player, floorY)

    camera:lookAt(player.x, player.y)

    -- Update the infiniteBackground based on the player's position
    infiniteBackground.update(player.x)
end

function Simulator.keypressed(key)
    if key == "space" and player.onGround then
        -- Trigger jump only if player is on the ground
        Gravity.jump(player)
    end
end

function Simulator.draw()
    camera:attach()

    -- Draw active backgrounds
    local activeBackgrounds = infiniteBackground.getActiveBackgrounds()
    for _, bg in ipairs(activeBackgrounds) do
        if bg.mirrored then
            love.graphics.draw(background_image, bg.x + background_image:getWidth() * bg_scale_width, 0, 0, -bg_scale_width, bg_scale_height)
        else
            love.graphics.draw(background_image, bg.x, 0, 0, bg_scale_width, bg_scale_height)
        end
    end

    -- Get the current animation frame and its dimensions
    local current_frame_image, frame_width, frame_height = animatel.getCurrentFrame()
    
    -- Scale the character based on the desired height
    local width_scale, height_scale = scaler.aspect_ratio_scaler_by_height(frame_width, frame_height, player.desired_height)
    
    -- Draw the character
    local character_draw_x = player.x - (frame_width * width_scale / 2)
    local character_draw_y = player.y - (frame_height * height_scale / 2)
    love.graphics.draw(current_frame_image, character_draw_x, character_draw_y, 0, flip_horizontal * width_scale, height_scale)

    camera:detach()
end


return Simulator
