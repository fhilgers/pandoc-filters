local latex = require 'latex'
local typst = require 'typst'
local meta = require 'meta'

local converter = {}

if FORMAT == 'latex' then
    converter = {
        Command = latex.Command,
        Environment = latex.Environment,
        RawCommand = latex.Command,
        RawEnvironment = latex.Environment
    }
elseif FORMAT == 'typst' then
    converter = {
        Command = typst.Command,
        Environment = typst.Command,
        RawCommand = typst.RawCommand,
        RawEnvironment = typst.RawCommand
    }
end

local function handle(el, textFn, convFn)
    if not meta.is_native_function(el) then return el end

    fname = meta.get_native_function(el)
    text = textFn(el)

    return convFn(fname, text, el.attributes)
end

local function handle_span(el)
    local text_from_code = function(el)
        return pandoc.write(pandoc.Pandoc(el), FORMAT, PANDOC_WRITER_OPTIONS)
    end
    return handle(el, text_from_code, converter.Command)
end

local function handle_div(el)
    local text_from_code = function(el)
        return pandoc.write(pandoc.Pandoc(el.content), FORMAT,
                            PANDOC_WRITER_OPTIONS)
    end
    return handle(el, text_from_code, converter.Environment)
end

local function handle_code(el)
    local text_from_code = function(el) return el.text end
    return handle(el, text_from_code, converter.RawCommand)
end

local function handle_codeblock(el)
    local text_from_code = function(el) return el.text end
    return handle(el, text_from_code, converter.RawEnvironment)
end

return {
    {Meta = meta.parse}, {
        Code = handle_code,
        CodeBlock = handle_codeblock,
        Div = handle_div,
        Span = handle_span
    }
}