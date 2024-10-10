local animatel = {}
local walking_images = {}
local current_frame = 1
local frames_per_step = 6 -- Number of frames for one complete step
local step_distance = 50 -- Pixels traveled during one complete step cycle
local time_elapsed = 0
local image_width, image_height

function animatel.loadWalkingAnimation()
    for i = 1, 85 do
        local file_path = string.format("assets/sprites/walking_animation/%d.png", i)
        local image = love.graphics.newImage(file_path)
        table.insert(walking_images, image)
    end
    
    image_width, image_height = walking_images[1]:getDimensions()
end

function animatel.update(dt, is_moving, current_speed)
    if is_moving and current_speed ~= 0 then
        -- Calculate how much distance we've moved
        local distance_moved = math.abs(current_speed) * dt
        
        -- Calculate how many frames we should advance based on distance moved
        local frames_to_advance = (distance_moved / step_distance) * frames_per_step
        
        time_elapsed = time_elapsed + frames_to_advance
        
        -- Update frame when we've accumulated enough for a frame change
        while time_elapsed >= 1 do
            current_frame = current_frame + 1
            if current_frame > #walking_images then
                current_frame = 1
            end
            time_elapsed = time_elapsed - 1
        end
    else
        -- Reset to first frame when not moving
        current_frame = 1
        time_elapsed = 0
    end
end

function animatel.getCurrentFrame()
    return walking_images[current_frame], image_width, image_height
end

return animatel