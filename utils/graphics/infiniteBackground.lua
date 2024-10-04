local infiniteBackground = {}

-- Constants
local BUFFER_ZONE = 0.5 -- Half a screen width buffer

-- State
local backgrounds = {}
local backgroundWidth = 0
local screenWidth = 0

function infiniteBackground.initialize(bgImage, bgScale, screenW)
    backgroundWidth = bgImage:getWidth() * bgScale
    screenWidth = screenW
    -- Initialize with three backgrounds
    for i = -1, 1 do
        table.insert(backgrounds, {x = i * backgroundWidth, active = true, mirrored = (i % 2 ~= 0)})
    end
end

function infiniteBackground.update(playerX)
    local viewportLeft = playerX - screenWidth / 2
    local viewportRight = playerX + screenWidth / 2

    -- Check if we need to add a new background to the right
    if viewportRight + screenWidth * BUFFER_ZONE > backgrounds[#backgrounds].x + backgroundWidth then
        local newBg = {
            x = backgrounds[#backgrounds].x + backgroundWidth, 
            active = true, 
            mirrored = not backgrounds[#backgrounds].mirrored
        }
        table.insert(backgrounds, newBg)
    end

    -- Check if we need to add a new background to the left
    if viewportLeft - screenWidth * BUFFER_ZONE < backgrounds[1].x then
        local newBg = {
            x = backgrounds[1].x - backgroundWidth, 
            active = true, 
            mirrored = not backgrounds[1].mirrored
        }
        table.insert(backgrounds, 1, newBg)
    end

    -- Deactivate backgrounds that are far off-screen
    for i, bg in ipairs(backgrounds) do
        bg.active = (bg.x + backgroundWidth >= viewportLeft - screenWidth * BUFFER_ZONE) and
                    (bg.x <= viewportRight + screenWidth * BUFFER_ZONE)
    end

    -- Remove excess backgrounds
    while #backgrounds > 3 and not backgrounds[1].active do
        table.remove(backgrounds, 1)
    end
    while #backgrounds > 3 and not backgrounds[#backgrounds].active do
        table.remove(backgrounds)
    end
end

function infiniteBackground.getActiveBackgrounds()
    return backgrounds
end

return infiniteBackground