-- utils/physics/collisions.lua
local Collisions = {}

function Collisions.checkFloorCollision(player, floorY)
    -- Simple floor collision detection
    if player.y + player.height / 2 >= floorY then
        player.y = floorY - player.height / 2
        player.speedY = 0  -- Stop downward movement when colliding with the floor
        player.onGround = true
    else
        player.onGround = false
    end
end

function Collisions.checkEntityFloorCollision(entity, floorY)
    -- Simple floor collision detection
    if entity.y + entity.r / 2 >= floorY then
        entity.y = floorY - entity.height / 2
        entity.speedY = 0  -- Stop downward movement when colliding with the floor
        entity.onGround = true
    else
        entity.onGround = false
    end
end

return Collisions
