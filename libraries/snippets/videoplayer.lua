--[[Intro class for Love 2D
About :		This is a class for load videos,center-it (give the good position) and add the correct scale (if the window is too small)
			It can load only one video but you can change the source if you want.
			It is very useful if you want to display a simple intro in your game.

Made by  :	Logan Tann for the "Kagerou Project Fangame (V2)".
			http://kagescan.esy.es/
			Under the MIT License
Version :	1.0
]] --
videoplayer = {} -- define the LUA class

videoplayer.init = function(vPath)
    local self = {}
    -- #variables
    local winW, winH = love.window.getMode()
    self.video = love.graphics.newVideo(vPath)
    self.height, self.width = self.video:getHeight(), self.video:getWidth()

    if self.height >= winH then
        self.scale = (winH) / self.height
        self.height, self.width = self.height * self.scale, self.width * self.scale
    else
        self.scale = 1
    end

    self.x, self.y = winW / 2 - self.width / 2, winH / 2 - self.height / 2

    -- #functions
    self.play = function()
        self.video:play()
    end
    self.pause = function()
        self.video:pause()
    end
    self.stop = function()
        self.video:pause()
    end

    return self
end
