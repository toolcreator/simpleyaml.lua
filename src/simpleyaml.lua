local simpleyaml = {}

function simpleyaml.parseFile(path)
  local function atNestingLevel(nestingLevel, f, data, tab)
    if nestingLevel == 0 then
      f(data, tab)
    else
      atNestingLevel(nestingLevel - 1, f, data, tab[#tab].val)
    end
  end

  local function insertKey(key, nestingLevel, tab)
    atNestingLevel(
      nestingLevel,
      function(k, t)
        table.insert(t, { key = k, val = {} })
      end,
      key,
      tab
    )
  end

  local function insertString(str, nestingLevel, table)
    atNestingLevel(
      nestingLevel,
      function(s, t)
        t[#t].val = s
      end,
      str,
      table
    )
  end

  local function flatten(parsed)
    local flattened = {}
    for _, item in ipairs(parsed) do
      if type(item.val) ~= "string" then
        flattened[item.key] = flatten(item.val)
      else
        flattened[item.key] = item.val
      end
    end
    return flattened
  end

  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local nestingLevel = 0
  local indents      = {}
  local parsed       = {}

  for line in file:lines() do
    if line:gsub("%s*", "") == "" then
      goto cont_processing_lines
    end

    local indent = line:match("(%s*)%S.*"):len()
    if #indents > 0 then
      local prevIndent = indents[#indents]

      if indent > prevIndent then
        nestingLevel = nestingLevel + 1;
      elseif indent < prevIndent then
        nestingLevel = nestingLevel - 1;
        while indents[#indents] > indent do
          if prevIndent < indents[#indents] then
            nestingLevel = nestingLevel + 1
          elseif prevIndent > indents[#indents] then
            nestingLevel = nestingLevel - 1
          end
          prevIndent = indents[#indents]
          table.remove(indents)
        end
      end
    end
    table.insert(indents, indent)

    local key = line:match("%s*(.*):")
    insertKey(key, nestingLevel, parsed)

    line = line:match(":%s*(.*)%s*")
    if line:len() > 0 then
      insertString(line, nestingLevel, parsed)
    end

    ::cont_processing_lines::
  end

  file:close()

  return flatten(parsed)
end

return simpleyaml
