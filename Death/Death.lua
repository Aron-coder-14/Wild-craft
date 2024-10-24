local Death = {}
local detectClick = require"utils.graphics.detectClick"
local death_screen_image
local DeathScreenImagePath="assets/deathScreen.png";
local button = {
    x = 50,
    y = 50,
    sx = 100,
    sy = 100,
    isClicked = false,
}


function Death.load()
    death_screen_image = love.graphics.newImage(DeathScreenImagePath)



end
 
function Death.update(dt)
    button.isClicked = detectClick.isRectClicked(button.x, button.y, button.sx, button.sy)
    if button.isClicked then 
        -- Reset player health to default when restarting
        player.health = player.default_health
        player.is_dead = false  -- Set is_dead to false to allow restarting
        currentGameState = GameStates.SIMULATOR
    end
end



function Death.draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(255,255,255,1)
    love.graphics.draw(death_screen_image, 0, 0)
    love.graphics.rectangle("fill", button.x, button.y, button.sx, button.sy)
end
return Death