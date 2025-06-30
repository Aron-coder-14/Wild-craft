local Death = {}
local detectClick = require "utils.graphics.detectClick"
local death_screen_image = {}
local DeathScreenImagePath = "assets/deathScreen.png";
local button = {x = 50, y = 50, sx = 100, sy = 100, isClicked = false}

local ImageH = require "utils.graphics.imageHelper"
local restartButton = ImageH("assets/restartButton.png")

function Death.load()
    death_screen_image.image = love.graphics.newImage(DeathScreenImagePath)
    death_screen_image.width,  death_screen_image.height  = death_screen_image.image:getDimensions()
end

function Death.update(dt)
    button.isClicked = detectClick.isRectClicked(button.x, button.y, button.sx,
                                                 button.sy)
    if button.isClicked then
        -- Reset player health to default when restarting
        player.health = player.default_health
        player.is_dead = false -- Set is_dead to false to allow restarting
        currentGameState = GameStates.SIMULATOR
    end
end

function Death.draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(255, 255, 255, 1)
    local sW, sH = love.graphics.getDimensions()
    local oX, oY = (sW - death_screen_image.width) / 2, (sH - death_screen_image.height) / 2
    love.graphics.draw(death_screen_image.image, oX, oY)
    love.graphics.rectangle("fill", button.x, button.y, button.sx, button.sy)


    restartButton:draw()
end
return Death
