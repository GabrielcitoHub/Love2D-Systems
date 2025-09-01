-- :3
local Utils = {
	_LICENSE     = "MIT/X11",
	_URL         = "",
	_VERSION     = "1.0",
	_DESCRIPTION = "Utils library designed for the *awesome* LÖVE framework.",
	cache        = {},
}

function Utils:warn(...)
    print("Warning: " .. ...)
end
function Utils.warn(...)
    Utils:warn(...)
end

function warn(...)
    Utils:warn(...)
end

function Utils:getParentFolder(path)
    return path:match("(.*/)[^/]+/?$") or ""
end

function Utils:getRelativePath()
    -- Get the current file's path
    local info = debug.getinfo(1, "S").source
    local basePath = info:match("@(.*/)")
    basePath = basePath and basePath:gsub("\\", "/") or ""
    basePath = basePath:gsub("^./", "")  -- make relative to root
    return basePath
end

function Utils:setSearchPaths(paths, extensions)
    Utils.paths = paths or {"assets/images/","assets/",""}
    Utils.extensions = extensions or {".png", ""}
end
Utils:setSearchPaths()

function Utils:findFile(path, paths, extensions)
    if not path then return end
    paths = Utils.paths or paths
    extensions = Utils.extensions or extensions
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
end

return Utils