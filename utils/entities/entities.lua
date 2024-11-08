local entities = {}
local entity = {
    x = 0, 
    y = 0,
    r = 8, 
    hasSpawned = false,
    speed = 0,
}
local spawnRadius = 150  -- Radius within which the entity will spawn around the player

function entities.load()
    entity.r = 8
    entity.speed = love.math.random(25, 50)
end

function entities.update(dt, player)
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
end 

function entities.draw()
    local mode = "fill"
    love.graphics.circle(mode, entity.x, entity.y, entity.r)
end

return entities
