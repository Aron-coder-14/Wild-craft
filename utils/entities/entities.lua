local entities = {}
local entity = {
    x = 0, 
    y = 0,
    r = 8, 
    hasSpawned = false,
    speed = 100,
    attack_radius = 15,
    damage = 10,
    cooldown = 0,          
    cooldownTime = 2.5,
    onGround = false,
    imagePath = 'assets/sprites/enemy/gorgoyl.png',  -- Fixed typo
    height = 0  -- Initialize height
}

local spawnRadius = 150  -- Radius within which the entity will spawn around the player
local canAttack
local collisions = require 'utils.physics.collisions'
local scaler = require 'utils.graphics.scaler'

-- Declare entity_image at the module level so it's accessible in all functions
local entity_image
local scaleX, scaleY

function entities.load()
    entity.r = 16
    entity.speed = love.math.random(25, 50)
    -- Load the image
    entity_image = love.graphics.newImage(entity.imagePath)
    local entity_image_height = entity_image:getHeight()
    local entity_image_width = entity_image:getWidth()

    -- Scale the image to match the desired radius
    scaleX, scaleY = scaler.aspect_ratio_scaler_by_width(entity_image_width, entity_image_height, entity.r * 2)
    
    -- Dynamically calculate height after scaling
    entity.height = entity_image_height * scaleY

end

function entities.update(dt, player, floorY)
    -- Spawn the entity around the player if it hasn't spawned yet
    if not entity.hasSpawned then
        -- Calculate a random angle and distance within the spawn radius
        local angle = love.math.random() * 2 * math.pi
        local distance = love.math.random(0, spawnRadius)
    
        -- Calculate entity's spawn position based on the player's position
        entity.x = player.x + math.cos(angle) * distance
        entity.y = player.y + math.sin(angle) * distance
        entity.hasSpawned = true
    end

    -- Calculate direction towards the player
    local dx = player.x - entity.x
    local dy = player.y - entity.y
    local distanceToPlayer = math.sqrt(dx * dx + dy * dy)

    -- Normalize the direction and update the position based on the speed
    if distanceToPlayer > 0 then
        local directionX = dx / distanceToPlayer
        local directionY = dy / distanceToPlayer

        -- Move the entity towards the player
        entity.x = entity.x + directionX * entity.speed * dt
        entity.y = entity.y + directionY * entity.speed * dt
    end

    if distanceToPlayer <= entity.attack_radius then
        canAttack = true
    else
        canAttack = false
    end

    -- Attack logic with cooldown
    if canAttack then
        -- Check if the cooldown has expired
        if entity.cooldown <= 0 then
            player.health = player.health - entity.damage
            entity.cooldown = entity.cooldownTime  -- Reset cooldown timer
        end
    end

    -- Decrease cooldown over time
    if entity.cooldown > 0 then
        entity.cooldown = entity.cooldown - dt
    end

    -- Check floor collision dynamically using entity.height
    collisions.checkEntityFloorCollision(entity, floorY)
end

function entities.draw()
    -- Ensure the image is drawn using the calculated scale
    love.graphics.draw(entity_image, entity.x, entity.y, 0, scaleX, scaleY)
end

return entities
