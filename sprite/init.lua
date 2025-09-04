---@diagnostic disable: deprecated
local spritemanager = {
	_LICENSE     = "MIT/X11",
	_URL         = "",
	_VERSION     = "1.0",
	_DESCRIPTION = "Sprite library designed for the *awesome* LÖVE framework.",
	cache        = {},
}

spritemanager.sprites = {}

local info = debug.getinfo(1, "S").source
local basePath = info:match("@(.*/)")
basePath = basePath and basePath:gsub("\\", "/") or ""
basePath = basePath:gsub("^./", "")  -- make relative to root
local parentPath = basePath:match("(.*/)[^/]+/?$") or ""

local utils = require(basePath .. "utils")
-- I made this!
-- (This took waaay too long to make... but it was worth it, imma finish the menu later)
-- G
--How in the fuk

function spritemanager:tagToSprite(tag)
    return spritemanager.sprites[tag]
end

function spritemanager:findImage(path)
    if not path then
        print("Invalid sprite path (nil)")
        return
    end

    local paths = {"assets/images/","assets/",""}
    local extensions = {".png", ""}
    for _,ext in ipairs(extensions) do
        for _,testpath in ipairs(paths) do
            local trypath = testpath .. path .. ext
            local exists = love.filesystem.getInfo(trypath)
            if exists then
                local image = love.graphics.newImage(trypath)
                return image
            end
        end
    end
    
    print("image " .. path .. " not found")
    return love.graphics.newImage(basePath .. "/PLACEHOLDER.png")
end

function spritemanager:makeLuaSprite(tag,path,x,y)
    local image = spritemanager:findImage(path)
    local spritedata = {
        tag = tag,
        path = path,
        image = image,
        x = x,
        y = y,
        r = 0,
        sx = 1,
        sy = 1,
        ox = 0,
        oy = 0,
        kx = 0,
        ky = 0,
        visible = true,
        order = 1
    }
    spritemanager.sprites[tag] = spritedata

    -- print(spritemanager.sprites[tag].tag .. "/ path: " .. spritemanager.sprites[tag].path)
end

function spritemanager:removeLuaSprite(tag)
    spritemanager.sprites[tag] = nil
    -- that ancient text below me... is ancient and soo cool!
    -- Uhh i don't think that sprite exists bro... im sorry
end

function spritemanager:updateSprite(tag, newSpr)
    spritemanager.sprites[tag] = newSpr
end

function spritemanager:getProperty(tag,property)
    return spritemanager.sprites[tag][property]
end

function spritemanager:setProperty(tag,property,value)
    spritemanager.sprites[tag][property] = value
end

-- first argument must be the sprite tag, second argument can either be "x", "y" or "xy", 
function spritemanager:centerObject(tag, type)
    type = string.lower(type)
    local xcenter = (love.graphics.getWidth()/2)
    local ycenter = (love.graphics.getHeight()/2)
    if type == "x" then
        spritemanager.sprites[tag].x = xcenter
    elseif type == "y" then
        spritemanager.sprites[tag].y = ycenter
    elseif type == "xy" then
        spritemanager.sprites[tag].x = xcenter
        spritemanager.sprites[tag].y = ycenter
    else
        -- Umh... invalid... input?
    end
end

function spritemanager:draw()
    -- Make a shallow copy of the sprite list
    local sorted = {}
    for i, spr in pairs(self.sprites) do
        sorted[#sorted+1] = spr
    end

    -- Sort by order
    table.sort(sorted, function(a, b)
        return a.order < b.order
    end)

    -- Draw in order
    for i, spr in ipairs(sorted) do
        if spr.visible then
            love.graphics.draw(
                spr.image,
                spr.x, spr.y,
                spr.r, spr.sx, spr.sy,
                spr.ox, spr.oy,
                spr.kx, spr.ky
            )
        end
    end
end


function spritemanager:clearSprites()
    spritemanager.sprites = {}
end

return spritemanager