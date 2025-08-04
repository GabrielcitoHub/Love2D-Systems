local mobile = {}
mobile.touches = {}
mobile.mobile = false

function mobile:touchpressed(id, x, y, dx, dy, pressure)
    mobile.touches[id] = {x = x, y = y}
    mobile.mobile = true
end

function mobile:touchmoved(id, x, y, dx, dy, pressure)
    mobile.touches[id] = {x = x, y = y}
end

function mobile:touchreleased(id, x, y, dx, dy, pressure)
    mobile.touches[id] = nil
end

function mobile:update()
    if love.keyboard.keysPressed then
        mobile.mobile = false
    end
end

function mobile:draw()
    for id, touch in pairs(mobile.touches) do
        love.graphics.circle("fill", touch.x * love.graphics.getWidth(), touch.y * love.graphics.getHeight(), 20)
    end
end

function mobile:getTouchPosition(touchid, pixel)
    for id, touch in pairs(mobile.touches) do
        if id == touchid then
            if not pixel then
                return touch.x,touch.y
            else
                return touch.x * love.graphics.getWidth(), touch.y * love.graphics.getHeight()
            end
        end
    end
    return nil
end

return mobile