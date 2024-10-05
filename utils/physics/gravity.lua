-- utils/physics/gravity.lua
local Gravity = {}

function Gravity.applyGravity(player, dt)
    -- Apply gravity only if the player is not on the ground
    if not player.onGround then
        -- Apply gravity force (acceleration)
        player.speedY = player.speedY + player.gravity * dt

        -- Cap the vertical speed to a terminal velocity (optional, tweak this as needed)
        local terminal_velocity = 800
        if player.speedY > terminal_velocity then
            player.speedY = terminal_velocity
        end

        -- Move the player downward by their vertical speed
        player.y = player.y + player.speedY * dt
    end
end

function Gravity.jump(player)
    if player.onGround then
        -- Apply jump force
        player.speedY = player.jumpForce
        player.onGround = false
    end
end

return Gravity
