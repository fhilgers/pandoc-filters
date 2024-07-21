local pandoc = require("pandoc")

local function format_namedargs(namedargs)
    if #namedargs == 0 then
        return ""
    end

    local fnamedargs = "["
    for k, v in pairs(namedargs) do
        fnamedargs = fnamedargs .. k .. "=" .. v .. ","
    end
    fnamedargs = string.sub(fnamedargs, 1, -2)

    return fnamedargs .. "]"
end

local latex = {}

latex.Command = function(cmdname, posarg, namedargs)
    local fnamedargs = format_namedargs(namedargs)
    return pandoc.RawInline("latex", "\\" .. cmdname .. fnamedargs .. "{" .. posarg .. "}")
end

latex.Environment = function(cmdname, posarg, namedargs)
    local fnamedargs = format_namedargs(namedargs)
    return pandoc.RawInline(
        "latex",
        "\\begin{" .. cmdname .. "}" .. fnamedargs .. "\n" .. posarg .. "\n\\end{" .. cmdname .. "}"
    )
end

return latex
