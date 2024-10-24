local detectClick = {}




function detectClick.isRectClicked(x, y, width, height)
    local mouseX, mouseY = love.mouse.getPosition()
    local isMouseClicked = love.mouse.isDown(1)



    if isMouseClicked and mouseX >= x and mouseY >= y and mouseY <= y + height and mouseX <= x + width then
        return true
        

    else 
        return false
        
    end
end   
return detectClick