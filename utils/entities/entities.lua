local entities={}
local entity = {
    x, 
    y,
    r, 
}



function entities.load()

end 

function entities.update(dt, player)

    entity.x = player.x 
    entity.y = player.y
    entity.r =100
end 

function entities.draw()

    mode = "fill"
    
    love.graphics.circle(mode, entity.x, entity.y, entity.r)






end



return entities