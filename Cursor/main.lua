--[[
    Your love2d game start here
]]


love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
    -- init something here ...
    love.mouse.setVisible(false)

    CCCursors = require "libs/cursor"
    mobile = require "libs/mobile"
    love.window.setTitle('Hello love2d!')
    cursor = CCCursors.cursor:newCursor(1)

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    -- ...
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- change some values based on your actions
    CCCursors.cursor:update(dt)
    love.keyboard.keysPressed = {}
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    mobile:touchmoved(id, x, y, dx, dy, pressure)
end

function love.draw()
    -- draw your stuff here
    CCCursors.cursor:draw()
    mobile:draw()
    love.graphics.print('Welcome to the Love2d world! ' .. #CCCursors.cursor.cursors, 10, 10)
end
