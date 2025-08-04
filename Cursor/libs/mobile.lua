local mobile = {}
mobile.touches = {}

function mobile:touchmoved(id, x, y, dx, dy, pressure)
    mobile.touches[id] = {x = x, y = y}
end

function mobile:draw()
    for id, touch in pairs(mobile.touches) do
        love.graphics.circle("fill", touch.x * love.graphics.getWidth(), touch.y * love.graphics.getHeight(), 20)
    end
end

return mobile