---@diagnostic disable: deprecated
local LevelLoader = {
	_LICENSE     = "MIT/X11",
	_URL         = "",
	_VERSION     = "1.0",
	_DESCRIPTION = "Level Loader library for sti designed for the *awesome* LÖVE framework.",
	cache        = {},
}

LevelLoader.world = {}

local cwd = (...):gsub('%.init$', '') .. "."
local info = debug.getinfo(1, "S").source
local basePath = info:match("@(.*/)")
basePath = basePath and basePath:gsub("\\", "/") or ""
basePath = basePath:gsub("^./", "")  -- make relative to root
local parentPath = basePath:match("(.*/)[^/]+/?$") or ""

local utils = require(basePath .. "utils")
local sti = require(basePath .. "sti")
local windfield = require(basePath .. "windfield/windfield")

local function setplrvariables(plr, plrdata)
    plr:setFixedRotation(true)

    for datakey,data in pairs(plrdata) do
        plr[datakey] = data
    end

    plr.setPosition = function(x,y)
        plr:destroy() -- I kind of liked to see more than one lol

        plr = LevelLoader.world:newBSGRectangleCollider(x, y, plrdata.width, plrdata.height, plrdata.roundness)
        setplrvariables(plr, plrdata)
        LevelLoader.player = plr
    end

    return plr
end

function LevelLoader:load()
    local plrdata = {
        x = 350,
        y = 100,
        width = 40,
        height = 80,
        roundness = 8,
        jumpforce = 2000,
        canjump = true,
        speed = 12000,
        maxspeed = 300,
        timers = {
            jump = 0.3
        },
        onfloor = true,
        jumping = false
    }
    self.world = self.windfield.newWorld(0, 800)

    self.player = LevelLoader.world:newBSGRectangleCollider(plrdata.x, plrdata.y, plrdata.width, plrdata.height, plrdata.roundness)

    setplrvariables(self.player, plrdata)
end

function LevelLoader:loadLevel(name, lvltype)
    lvltype = lvltype or "image"

    if lvltype == "image" then
        LevelLoader.level = {
            type = "image",
            image = name
        }
    elseif lvltype == "map" then
        LevelLoader.level = {
            type = "map",
            map = sti(name)
        }
    end

    if LevelLoader.level then
        if LevelLoader.levelload then
            LevelLoader:levelLoad(LevelLoader.level, "loaded")
        end
    else
        warn("Error! Could not load map " .. name)
        if LevelLoader.levelload then
            LevelLoader:onLoadLevel(LevelLoader.level, "failed")
        end
    end
end

function LevelLoader:update(dt)
    if self.level then
        if self.level["type"] == "map" then
            self.level["map"]:update(dt)
        end
        self.world:update(dt)
        -- cam:lookAt(self.player:getX(), self.player:getY())
    end
end

function LevelLoader:draw()
    if LevelLoader.level then
        if LevelLoader.level["type"] == "map" then
            if LevelLoader.level["map"].layers then
                for _,layer in ipairs(LevelLoader.level["map"].layers) do
                    if layer.name ~= "collision" and layer.name ~= "markers" and layer.name ~= "objects" then
                        LevelLoader.level["map"]:drawLayer(layer)
                    end
                end
            end
        end
        self.world:draw()
    end
end

return LevelLoader