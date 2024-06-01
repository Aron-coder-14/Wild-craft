@echo off

REM Check if the "libraries" folder exists
IF NOT EXIST libraries (
    REM Create the "libraries" folder
    mkdir libraries
)

REM Navigate to the "libraries" folder and clone the repositories using PowerShell
powershell -Command "cd libraries; git clone https://github.com/tesselode/baton; git clone https://github.com/a327ex/windfield; git clone https://github.com/vrld/hump.git; git clone https://github.com/ittner/lua-gd.git; git clone https://github.com/LuaDist/dkjson.git; git clone https://github.com/vrld/suit.git; git clone https://github.com/vrld/moonshine.git; git clone https://github.com/pablomayobre/material-love.git; git clone https://github.com/kikito/tween.lua.git"
