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
local entities = require 'utils.entities.entities'               


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

    infiniteBackground.initialize(background_image, bg_scale_width, screenWidth)

    camera:lookAt(player.x, player.y)

    entities.load()

end

function Simulator.update(dt)
    local targetSpeedX = 0
    local is_moving = false

    if love.keyboard.isDown("right", "d") then
        is_going_left = false
        targetSpeedX = player.maxSpeedX
        is_moving = true
    elseif love.keyboard.isDown("left", "a") then
        is_going_left = true
        targetSpeedX = -player.maxSpeedX
        is_moving = true
    end
    if love.keyboard.isDown("space") and player.onGround then
        Gravity.jump(player)
    end

    -- Smoothly adjust current speed towards target speed
    if is_moving then
        if player.currentSpeedX < targetSpeedX then
            player.currentSpeedX = math.min(player.currentSpeedX + player.acceleration * dt, targetSpeedX)
        elseif player.currentSpeedX > targetSpeedX then
            player.currentSpeedX = math.max(player.currentSpeedX - player.acceleration * dt, targetSpeedX)
        end
    else
        -- Decelerate when no movement input
        if player.currentSpeedX > 0 then
            player.currentSpeedX = math.max(player.currentSpeedX - player.deceleration * dt, 0)
        elseif player.currentSpeedX < 0 then
            player.currentSpeedX = math.min(player.currentSpeedX + player.deceleration * dt, 0)
        end
    end

    -- Update player position
    player.x = player.x + player.currentSpeedX * dt

    -- Update animation with actual speed
    animatel.update(dt, is_moving, player.currentSpeedX)

    flip_horizontal = is_going_left and -1 or 1

    -- Apply gravity and check collisions
    Gravity.applyGravity(player, dt)
    Collisions.checkFloorCollision(player, floorY)

    camera:lookAt(player.x, player.y)
    infiniteBackground.update(player.x)
    if player.health <= 0 then
        player.is_dead = true

    end
    if player.is_dead then
        currentGameState = GameStates.DEATH
    end

    entities.update(dt, player, floorY)
end

function Simulator.keypressed(key)
    -- if key == "space" and player.onGround then
    --     Gravity.jump(player)
    -- end
    -- this is where keypressed funcs are called.
    if key == "k" then
        player.health = player.health -50
    end
    if key == "p" then
        player.health = player.health +50
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
        entities.draw()
        camera:detach()
        


        
        love.graphics.print(tostring(player.health),0,0,0,6,6)
  
    
end 
return Simulator