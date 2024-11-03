local space = {}
local scaler = require "utils.graphics.scaler"
local bg_image_path = "assets/landscape/spacePicture.jpg"
local bg_image
local bg_sx, bg_sy


function space.load()

    bg_image = love.graphics.newImage( bg_image_path)
    bg_width, bg_height=bg_image:getDimensions()
    bg_sx, bg_sy=scaler.backgroundscaler(bg_width, bg_height)


end

function space.draw()
    love.graphics.draw(bg_image, 0, 0, 0, bg_sx, bg_sy)
   

end
return space