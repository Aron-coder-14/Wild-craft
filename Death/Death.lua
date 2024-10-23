local Death = {}
local death_screen_image
local DeathScreenImagePath="assets/deathScreen.png";



function Death.load()
    death_screen_image = love.graphics.newImage(DeathScreenImagePath)



end






function Death.draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(255,255,255,1)
    love.graphics.draw(death_screen_image, 0, 0)
end
return Death