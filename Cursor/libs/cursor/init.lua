--- Simple and fast cursor renderer.
-- @module ccc
-- @license MIT/X11

---@class CCCModule
---@field cursor CursorModule
---@field _LICENSE string
---@field _URL string
---@field _VERSION string
---@field _DESCRIPTION string
---@field cache table
---@class CCC

local cwd = (...):gsub('%.init$', '') .. "."

---@type CCCModule
local CCC = {
	_LICENSE     = "MIT/X11",
	_URL         = "",
	_VERSION     = "1.0",
	_DESCRIPTION = "Cool Custom Cursors is an easy to use cursor sprite renderer library designed for the *awesome* LÖVE framework.",
	cache        = {},
	cursor       = require(cwd .. "cursor")
}

return CCC