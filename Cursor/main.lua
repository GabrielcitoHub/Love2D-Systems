--[[
    Your love2d game start here
]]

CCCursors = require "libs/cursor"

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
    -- init something here ...
    love.mouse.setVisible(false)

    love.window.setTitle('Hello love2d!')
    cursor = CCCursors.cursor:newCursor(1)

    love.keyboard.keysPressed = {}
end

function CCCursors.cursor:idle(cursor)
    local cursorpos = cursor.position
    -- print("A cursor is idling!")
    if cursorpos then
        print(tostring(cursorpos["x"] .. " / " .. cursorpos["y"]))
    end
end

function CCCursors.cursor:onPressed(cursor)
    love.audio.newSource("click.wav","static"):play()
    local cursorpos = cursor.position
    print("A cursor was pressed!")
    if cursorpos then
        print(tostring(cursorpos["x"] .. " / " .. cursorpos["y"]))
    end
end

function CCCursors.cursor:hold(cursor)
    -- print("A cursor is being hold!")
end

function CCCursors.cursor:onReleased(cursor)
    print("A cursor was released!")
end

function love.resize(w, h)
    -- ...
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- change some values based on your actions
    CCCursors.cursor:update(dt)
    love.keyboard.keysPressed = {}
end

-- Keyboard support

function love.keypressed(key, scancode, isrepeat)
    CCCursors.cursor:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

-- Mobile support

function love.touchpressed(id, x, y, dx, dy, pressure)
    CCCursors.cursor:touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    CCCursors.cursor:touchmoved(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    CCCursors.cursor:touchreleased(id, x, y, dx, dy, pressure)
end

function love.draw()
    -- draw your stuff here
    CCCursors.cursor:draw()
    love.graphics.print('Welcome to the Love2d world! ' .. #CCCursors.cursor.cursors, 10, 10)
end
