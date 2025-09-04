local stateManager = {
	_LICENSE     = "MIT/X11",
	_URL         = "",
	_VERSION     = "1.0",
	_DESCRIPTION = "State Manager library designed for the *awesome* LÖVE framework.",
	cache        = {},
}
stateManager.state = {}
stateManager.lastState = {}
stateManager.debug = false

local info = debug.getinfo(1, "S").source
local basePath = info:match("@(.*/)")
basePath = basePath and basePath:gsub("\\", "/") or ""
basePath = basePath:gsub("^./", "")  -- make relative to root
local parentPath = basePath:match("(.*/)[^/]+/?$") or ""

-- function safeStateCall(funcName) -- Only use IF EXTREMELY NECCESARY, IT LAGS REALLY BAD
--     if stateManager.state[funcName] ~= nil then
--         stateManager.state[funcName]()
--     end
-- end

-- Sets a new path to search for states paths
---@param newfolder string
function stateManager:setStatesPath(newfolder)
    stateManager.setpath = newfolder
end

-- Loads a state into the state manager
---@param newstate string
function stateManager:loadState(newstate)
    local newpath
    if stateManager.setpath then
        newpath = stateManager.setpath .. newstate
    else
        newpath = "states/" .. newstate
    end
    local searchpath = newpath
    if not love.filesystem.getInfo(searchpath) then
        for _,state in pairs(love.filesystem.getDirectoryItems("states")) do
            if state == newstate then
                searchpath = "states/" .. state
                return 
            end
        end
    end
    stateManager.state = require(searchpath)
    stateManager.state.name = newstate

    if stateManager.laststate then
        package.loaded["states." .. stateManager.laststate.name] = nil
    end

    -- Call module load function
    if stateManager.load ~= nil then
        stateManager:load(stateManager.state)
    end

    -- Call state load function
    if stateManager.state.load then
        stateManager.state:load()
    end

    stateManager.laststate = stateManager.state
end

function stateManager:draw()
    if stateManager.state.draw then
        stateManager.state:draw()
    end
    if stateManager.debug then
        love.graphics.print("state.id." .. stateManager.state.id, 0, 20)
    end
end

function stateManager:update(dt)
    if stateManager.state.update then
        stateManager.state:update(dt)
    end
end

function stateManager:keypressed(key)
    if stateManager.state.keypressed then
        stateManager.state:keypressed(key)
    end
end

return stateManager