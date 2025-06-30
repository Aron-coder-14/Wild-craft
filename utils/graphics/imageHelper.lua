local Class = require "libraries.hump.class"

local ImageHelper = Class{}

---@class ImageHelper
---@field image love.Image
---@field width number
---@field height number
---@overload fun(image_path: string): ImageHelper
function ImageHelper:init(imagePath)
    self.image = love.graphics.newImage(imagePath)
    self.width, self.height = self.image:getDimensions()
end


function ImageHelper:draw(x, y, r, sx, sy, ox, oy)
    love.graphics.draw(self.image, x, y, r or 0, sx or 1, sy or 1, ox or 0, oy or 0)
end

return ImageHelper