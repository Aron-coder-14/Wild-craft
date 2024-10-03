local scaler = {}

function scaler.backgroundscaler(width, height)
    local desired_width=screenWidth
    local desired_height=screenHeight
    local width_scale, height_scale=scaler.scaler(width, height, desired_width, desired_height)
    return width_scale, height_scale
end

function scaler.scaler(width, height, desired_width, desired_height)
    local height_scale=desired_height/height
    local width_scale=desired_width/width
    return width_scale, height_scale
end

return scaler