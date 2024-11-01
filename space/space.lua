local space = {}
local scaler = require "utils.graphics.scaler"
local bg_image_path = "assets/landscape/spacePicture.jpg"
local bg_image



function space.load()

    bg_image = love.graphics.newImage( bg_image_path)



end

function space.draw()

    love.graphics.rectangle("fill",0,0,100,100)


end
return space