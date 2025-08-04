---@class CursorModule
---@field cursors table<string, CursorData>
---@field newCursor fun(self: CursorModule, id: string|integer|nil, sprite: string|nil, width: number|nil, height: number|nil, rotation: number|nil, active: boolean|nil): CursorData?
---@field update fun(self: CursorModule, dt: number)
---@field draw fun(self: CursorModule)
---@field updateState fun(self: CursorModule, cursor: CursorData, dt: number, index:string|integer|nil?)

---@class CursorData
---@field path string
---@field sprite love.Image
---@field controller string
---@field type string
---@field state string
---@field active boolean
---@field visible boolean
---@field position {x: number, y: number , rotation: number}
---@field size {width: number, height: number}
---@field color {red: number, green: number , blue: number, alpha: number}

---@type CursorModule
---@diagnostic disable-next-line
local Cursor = {}

-- Get the current file's path
local info = debug.getinfo(1, "S").source
local basePath = info:match("@(.*/)")
basePath = basePath and basePath:gsub("\\", "/") or ""
basePath = basePath:gsub("^./", "")  -- make relative to root

-- Get the parent directory by removing the last segment
local parentPath = basePath:match("(.*/)[^/]*$")

local mobile = require(parentPath .. "mobile.lua")

Cursor.cursors = {}
-- print("Created cursors")

-- Creates a new cursor to use
function Cursor:newCursor(id, sprite, width, height, rotation, active)
    if not id then id = tostring((#Cursor.cursors or 1)) end
    -- print(id)
    -- print(#Cursor.cursors)
    if not sprite then sprite = basePath .. "default.png" end
    if not width then width = 16 end
    if not height then height = 16 end
    if not rotation then rotation = 0 end

    local realsprite = love.graphics.newImage(sprite)
    -- print(sprite)
    local data = {
        path = sprite,
        sprite = realsprite,
        controller = "mouse",
        type = "dynamic",
        state = "idle",
        active = false,
        visible = true,
        position = {
            x = 0,
            y = 0,
            rotation = rotation
        },
        size = {
            width = width,
            height = height
        },
        color = {
            red = 1,
            green = 1,
            blue = 1,
            alpha = 1
        }
    }

    if next(Cursor.cursors) == nil then -- Check if table is empty
        data.active = active ~= false -- default to true
    else
        data.active = active or false
    end

    Cursor.cursors[id] = data

    return data
end

function Cursor:updateState(cursor, dt, index)
    if cursor.state == "idle" then
    elseif cursor.state == "click" then
    elseif cursor.state == "release" then
    end

    if cursor.type == "static" then
        -- Static does do anything lol
    elseif cursor.type == "dynamic" then
        if index then
            if cursor.controller == "mouse" then
                if mobile.mobile then
                    cursor.controller = "touch"
                    Cursor.cursors[index] = cursor
                end
            elseif cursor.controller == "touch" then
                if not mobile.mobile then
                    cursor.controller = "mouse"
                    Cursor.cursors[index] = cursor
                end
            end
        end
    end

    local x,y = 0, 0

    if cursor.controller == "mouse" then
        x, y = love.mouse.getPosition()
    elseif cursor.controller == "touch" then
        x, y = mobile:getTouchPosition(1, true)
    end
    cursor.position.x, cursor.position.y = x, y
end

function Cursor:update(dt)
    for index,cursor in pairs(Cursor.cursors) do
        if cursor.active then
            Cursor:updateState(cursor, dt, index)
        end
    end
end

function Cursor:draw()
    for index,cursor in pairs(Cursor.cursors) do
        if cursor.active then
            love.graphics.setColor(cursor.color.red, cursor.color.green, cursor.color.blue, cursor.color.alpha)
            love.graphics.draw(cursor.sprite, cursor.position.x, cursor.position.y, cursor.position.rotation, cursor.size.width / 16, cursor.size.height / 16)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

return Cursor