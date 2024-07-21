local pandoc = require("pandoc")

local function format_namedargs(namedargs)
    if #namedargs == 0 then
        return ""
    end

    local fnamedargs = ""
    for k, v in pairs(namedargs) do
        fnamedargs = fnamedargs .. k .. ': "' .. v .. '", '
    end
    fnamedargs = string.sub(fnamedargs, 1, -3)

    return fnamedargs
end

local function escape_text(text)
    local etext = string.gsub(text, "\\", "\\\\")
    etext = string.gsub(etext, '"', '\\"')

    return '"' .. etext .. '"'
end

local typst = {}

typst.Command = function(cmdname, posarg, namedargs)
    local fnamedargs = format_namedargs(namedargs)
    return pandoc.RawInline("typst", "#" .. cmdname .. "(" .. fnamedargs .. ")[" .. posarg .. "]")
end

typst.RawCommand = function(cmdname, posarg, namedargs)
    local eposarg = escape_text(posarg)
    local fnamedargs = format_namedargs(namedargs)
    if #namedargs > 0 then
        fnamedargs = ", " .. fnamedargs
    end
    return pandoc.RawInline("typst", "#" .. cmdname .. "(" .. eposarg .. fnamedargs .. ")")
end

return typst
