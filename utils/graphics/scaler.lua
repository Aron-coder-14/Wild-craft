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

function scaler.aspect_ratio_scaler_by_width(original_width, original_height, desired_width)
    -- Calculate the aspect ratio
    local aspect_ratio = original_width / original_height

    -- Calculate the corresponding height that maintains the aspect ratio
    local desired_height = desired_width / aspect_ratio

    -- Return the scales to fit into the new dimensions
    local width_scale, height_scale = scaler.scaler(original_width, original_height, desired_width, desired_height)
    return width_scale, height_scale
end

function scaler.aspect_ratio_scaler_by_height(original_width, original_height, desired_height)
    -- Calculate the aspect ratio
    local aspect_ratio = original_width / original_height

    -- Calculate the corresponding width that maintains the aspect ratio
    local desired_width = desired_height * aspect_ratio

    -- Return the scales to fit into the new dimensions
    local width_scale, height_scale = scaler.scaler(original_width, original_height, desired_width, desired_height)
    return width_scale, height_scale
end


return scaler