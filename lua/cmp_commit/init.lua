local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function()
  return { '*', '[', '{' }
end

source.default_config = {
  format = { "", "" },
  length = -1,
  block = "ls -RA -I.git -p | grep -v / | uniq | tail -n +3",
  path = ""
}

source.setup = function(config)
  if config.format ~= nil and #config.format == 2 then
    source.default_config.format = config.format
  end
  if config.length ~= nil and config.length > 0 then
    source.default_config.length = config.length
  end
  if config.block ~= nil and type(config.block) == "table" then
    local dirs = ""
    for _, dir in pairs(config.block) do
      dirs = string.format('%s %s', dirs, string.format('-I%s', dir))
    end
    source.default_config.block = string.format('%s %s %s', 'ls -RA -I.git', dirs, '-p | grep -v / | uniq | tail -n +3')
  end
end

source.complete = function(self, request, callback)
  local input = string.sub(request.context.cursor_before_line, request.offset - 1)
  local items
  if input == '*' then
    items = self._source("git branch --show-current", request, input)
  elseif input == '[' or input == '{' then
    items = self._source(source.default_config.block, request, input)
  end
  callback(items)
end

source._source = function(src, request, input)
  local items = {}
  local pipe = io.popen(src)
  local value
  if pipe ~= nil then
    value = input == '*' and
        string.format('%s%s%s', source.default_config.format[1], pipe:read('l'), source.default_config.format[2]) or
        pipe:read('a')
  end
  ---@diagnostic disable-next-line: need-check-nil, missing-parameter
  pipe.close()
  for line in value:gmatch("[^\r\n]+") do
    table.insert(items, {
      label = line,
      textEdit = {
        newText = input == '{' and string.sub(line, 0, source.default_config.length) or line,
        range = {
          start = {
            line = request.context.cursor.row - 1,
            character = request.context.cursor.col - 1 - #input
          },
          ['end'] = {
            line = request.context.cursor.row - 1,
            character = request.context.cursor.col - 1
          }
        }
      }
    })
  end
  return items
end

return source
