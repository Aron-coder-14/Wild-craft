local animatel = {}
local walking_images = {}
local current_frame = 1
local animation_speed = 0.1 -- Adjust this to control animation speed
local time_elapsed = 0
local image_width, image_height -- Store the dimensions of the first frame

-- Load the walking animation frames and set the scaling factor
function animatel.loadWalkingAnimation()
    for i = 1, 85 do
        local file_path = string.format("assets/sprites/walking_animation/%d.png", i)
        local image = love.graphics.newImage(file_path)
        table.insert(walking_images, image)
    end
    
    -- Use the first image to determine the size and set the scaling
    image_width, image_height = walking_images[1]:getDimensions()
end

-- Update the current frame based on time and player movement
function animatel.update(dt, is_moving)
    if is_moving then
        time_elapsed = time_elapsed + dt
        if time_elapsed >= animation_speed then
            current_frame = current_frame + 1
            if current_frame > #walking_images then
                current_frame = 1
            end
            time_elapsed = 0
        end
    else
        -- If the player stops, reset the animation
        current_frame = 1
    end
end

-- Get the current frame to draw
function animatel.getCurrentFrame()
    return walking_images[current_frame], image_width, image_height
end

return animatel
