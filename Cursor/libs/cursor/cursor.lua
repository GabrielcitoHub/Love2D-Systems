---@class CursorModule
---@field cursors table<string, CursorData>
---@field newCursor fun(self: CursorModule, id: string|integer|nil, sprite: string|nil, width: number|nil, height: number|nil, rotation: number|nil, active: boolean|nil): CursorData?
---@field update fun(self: CursorModule, dt: number)
---@field draw fun(self: CursorModule)
---@field updateState fun(self: CursorModule, cursor: CursorData, dt: number, index:string|integer|nil?)
---@field idle fun(self: CursorModule, cursor: CursorData, dt: integer)
---@field onPressed fun(self: CursorModule, cursor: CursorData)
---@field hold fun(self: CursorModule, cursor: CursorData, dt: integer)
---@field onReleased fun(self: CursorModule, cursor: CursorData)

---@class CursorData
---@field path string
---@field sprite love.Image
---@field controller string
---@field type string
---@field state string
---@field down boolean
---@field active boolean
---@field visible boolean
---@field position {x: number, y: number , rotation: number}
---@field size {width: number, height: number}
---@field color {red: number, green: number , blue: number, alpha: number}

---@type CursorModule
---@diagnostic disable-next-line
local Cursor = {}

local function getParentFolder(path)
    return path:match("(.*/)[^/]+/?$") or ""
end

-- Get the current file's path
local info = debug.getinfo(1, "S").source
local basePath = info:match("@(.*/)")
basePath = basePath and basePath:gsub("\\", "/") or ""
basePath = basePath:gsub("^./", "")  -- make relative to root

-- Get the parent directory by removing the last segment
local parentPath = getParentFolder(basePath)
-- print("Parent Path:", parentPath)

local mobile = require(parentPath .. "mobile")

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
        down = false,
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
    local oldcursor = cursor

    if cursor.controller == "mouse" then
        cursor.down = love.mouse.isDown(1)
    elseif cursor.controller == "touch" then
        if next(mobile.touches) ~= nil then
            cursor.down = true
        elseif next(mobile.touches) == nil then
            cursor.down = false
        end
    end

    if cursor.state == "idle" then
        if cursor.down then
            if Cursor.idle then
                Cursor:idle(cursor, dt)
            end
            cursor.state = "click"
        end
    elseif cursor.state == "click" then
        if Cursor.onPressed then
            Cursor:onPressed(cursor)
        end
        cursor.state = "hold"
    elseif cursor.state == "hold" then
        if Cursor.hold then
            Cursor:hold(cursor, dt)
        end
        if not cursor.down then
            cursor.state = "release"
        end
    elseif cursor.state == "release" then
        if Cursor.onReleased then
            Cursor:onReleased(cursor)
        end
        cursor.state = "idle"
    end

    if cursor.type == "static" then
        -- Static does do anything lol
    elseif cursor.type == "dynamic" then
        if cursor.controller == "mouse" then
            if mobile.mobile then
                cursor.controller = "touch"
            end
        elseif cursor.controller == "touch" then
            if not mobile.mobile then
                cursor.controller = "mouse"
            end
        end
    end

    -- Update changes (if any)
    if oldcursor ~= cursor then
        if index then
            Cursor.cursors[index] = cursor
        end
    end

    local x,y = 0, 0

    if cursor.controller == "mouse" then
        x, y = love.mouse.getPosition()
    elseif cursor.controller == "touch" then
        local touchposition = mobile:getTouchPosition(1, true)
        if touchposition then
            x, y = touchposition[1], touchposition[2]
        end
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