local Utils = {
	_LICENSE     = "MIT/X11",
	_URL         = "",
	_VERSION     = "1.0",
	_DESCRIPTION = "Utils library designed for the *awesome* LÖVE framework.",
	cache        = {},
}

Utils.warn = function(...)
    print("Warning: " .. ...)
end

Utils.getParentFolder = function(path)
    return path:match("(.*/)[^/]+/?$") or ""
end

Utils.getRelativePath = function()
    -- Get the current file's path
    local info = debug.getinfo(1, "S").source
    local basePath = info:match("@(.*/)")
    basePath = basePath and basePath:gsub("\\", "/") or ""
    basePath = basePath:gsub("^./", "")  -- make relative to root
    return basePath
end

return Utils