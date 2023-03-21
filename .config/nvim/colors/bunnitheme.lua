require('colorbuddy').setup()
local Color = require('colorbuddy').Color
local Group = require('colorbuddy').Group
local g = require('colorbuddy.group').groups
local c = require('colorbuddy.color').colors
local s = require('colorbuddy.style').styles
local b = s.bold
local i = s.italic
local n = s.inverse
local uc = s.undercurl
local ul = s.underline
local r = s.reverse
local sto = s.standout
local no = s.NONE
local v = vim.g

v.colors_name = 'bunnitheme'

local palette = {
    background = "#171717",
    foreground = "#C5C8C6",
    comment = "#282a2e",
    green = "#31BB71",
    pink = "#FF64C8",
    purple = "#6B50FF",
    red = "#D74E6F",
    yellow = "#D3E561",
}

-- initialize all colors from palette
for key, value in pairs(palette) do
    Color.new(key, value)
end

Group.new('Normal', c.foreground, c.none, no)
Group.new('String', c.green, c.none, no)
Group.new('Comment', c.comment, c.none, i)
Group.new('Underlined', c.green, c.none, ul)
Group.new('Error', c.red, c.none, no)
Group.new('Todo', c.cyan, c.none, no)
Group.new('Special', c.foreground, c.none, no)
Group.new('Identifier', c.foreground, c.none, no)
Group.new('Label', c.foreground, c.none, no)
Group.new('LineNr', c.foreground, c.none, no)
Group.new('Typedef', c.purple, c.none, no)
Group.new('Conditional', c.pink, c.none, no)
Group.new('Function', c.purple, c.none, no)
Group.new('Include', c.yellow, c.none, no)
Group.new('Operator', c.foreground, c.none, no)

Group.new('StatusLine', c.pink, c.none, no)
Group.new('StatusLineTermNC', c.pink, c.none, no)

-- status line of current window
-- yes ok
