---@class MobileModule
---@field touches table
---@field mobile boolean
---@field touchpressed fun(self: MobileModule, id: integer, x: integer, y: integer, dx: integer, dy: integer, pressure: number)
---@field touchmoved fun(self: MobileModule, id: integer, x: integer, y: integer, dx: integer, dy: integer, pressure: number)
---@field touchreleased fun(self: MobileModule, id: integer, x: integer, y: integer, dx: integer, dy: integer, pressure: number)
---@field keypressed fun(self: MobileModule, key: love.KeyConstant, scancode:string, isrepeat: boolean)
---@field draw fun(self: MobileModule)
---@field getTouchPosition fun(self: MobileModule, touchid: integer, pixel: boolean): touchpositions: table|nil

---@type MobileModule
---@diagnostic disable-next-line
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

function mobile:keypressed(key, scancode, isrepeat)
    mobile.mobile = false
end

function mobile:draw()
    for id, touch in pairs(mobile.touches) do
        love.graphics.print("Mobile mobile.x:" .. touch.x .. " mobile.y:" .. touch.y .. " mobile.pixel.x:" .. touch.x * love.graphics.getWidth() .. " mobile.pixel.y" .. touch.y * love.graphics.getHeight() ,0,30 * (#mobile.touches or 1))
        love.graphics.circle("fill", touch.x * love.graphics.getWidth(), touch.y * love.graphics.getHeight(), 20)
    end
end

function mobile:getTouchPosition(touchid, pixel)
    local savetouchx = 0
    local savetouchy = 0
    for id, touch in pairs(mobile.touches) do
        if pixel then
            savetouchx, savetouchy = touch.x, touch.y
        else
            savetouchx, savetouchy = (touch.x * love.graphics.getWidth()), (touch.y * love.graphics.getHeight())
        end
        if id == touchid then
            if not pixel then               
                return {x = touch.x, y = touch.y}
            else
                return {x = (touch.x * love.graphics.getWidth()), y = (touch.y * love.graphics.getHeight())}
            end
        end
    end
    if next(mobile.touches) ~= nil then
        return {x = savetouchx, y = savetouchy}
    else
        return nil
    end
end

return mobile