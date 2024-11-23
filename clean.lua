local pandoc = require 'pandoc'

-- Remove empty HTML blocks
function RawInline(el)
    if el.format == "html" and el.content == nil then
        return pandoc.Space()
    end
end

-- Remove headers metadata
function Header(el)
    return pandoc.Header(el.level, el.content, nil)
end

-- Convert links to text
function Link(el)
    return el.content
end

-- Remove document metadata
function Pandoc(doc)
    return pandoc.Pandoc(doc.blocks, nil)
end
