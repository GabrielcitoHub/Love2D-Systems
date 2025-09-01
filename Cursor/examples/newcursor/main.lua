CCCursors = require "cursor"

function love.load()
    love.window.setTitle('Cursor Example')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.mouse.setVisible(false)

    _G.cursor = CCCursors:newCursor(1)
end

function CCCursors:idle(cursor)
    local cursorpos = cursor.position

    if cursorpos then
        print(tostring(cursorpos["x"] .. " / " .. cursorpos["y"]))
    end
end

function CCCursors:onPressed(cursor)
    local cursorpos = cursor.position

    print("A cursor was pressed!")
    if cursorpos then
        print(tostring(cursorpos["x"] .. " / " .. cursorpos["y"]))
    end
end

function CCCursors:hold(cursor)
    print("A cursor is being held!")
end

function CCCursors:onReleased(cursor)
    print("A cursor was released!")
end

function love.update(dt)
    CCCursors:update(dt)
end

-- Keyboard support

function love.keypressed(key, scancode, isrepeat)
    CCCursors:keypressed(key, scancode, isrepeat)
end

-- Mobile support

function love.touchpressed(id, x, y, dx, dy, pressure)
    CCCursors:touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    CCCursors:touchmoved(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    CCCursors:touchreleased(id, x, y, dx, dy, pressure)
end

function love.draw()
    CCCursors:draw()
    love.graphics.print(#CCCursors.cursors .. " / " .. cursor.controller, 10, 10)
end
