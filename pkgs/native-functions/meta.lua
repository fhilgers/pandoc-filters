local pandoc = require("pandoc")

local native_functions = {}

local meta = {}

meta.parse = function(m)
    if m["native_functions"] then
        for _, v in ipairs(m["native_functions"]) do
            if pandoc.utils.type(v) ~= "Inlines" then
                error("native_functions must be a list of strings")
            end

            if #v ~= 1 then
                error("native_functions must be a list of strings")
            end

            if v[1].t ~= "Str" then
                error("native_functions must be a list of strings")
            end

            native_functions[v[1].text] = true
        end
    end
end

meta.is_native_function = function(el)
    local found = {}
    for _, v in ipairs(el.classes) do
        if native_functions[v] then
            found[#found + 1] = v
        end
    end

    if #found == 0 then
        return false
    elseif #found == 1 then
        return true
    else
        found = table.concat(found, ", ")
        local text = pandoc.json.encode(el)
        error("multiple native functions found for " .. text .. ": " .. found)
    end
end

meta.get_native_function = function(el)
    for _, v in ipairs(el.classes) do
        if native_functions[v] then
            return v
        end
    end
end

return meta
