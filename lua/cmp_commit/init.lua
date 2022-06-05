local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function()
  return { '*', '[', '{' }
end

source.complete = function(self, request, callback)
  local input = string.sub(request.context.cursor_before_line, request.offset - 1)
  local items
  if input == '*' then
    items = self._source("git branch --show-current", request, input)
  elseif input == '[' then
    items = self._source("git status -s | awk '{print $2}'", request, input)
  else
    items = self._source('ls -RA -Inode_modules -I.git -p | grep -v / | sort | uniq | tail -n +3', request, input)
  end
  callback(items)
end

source._source = function(src, request, input)
  local items = {}
  local pipe = io.popen(src)
  local value
  if pipe ~= nil then
    value = pipe:read("a")
  end
---@diagnostic disable-next-line: need-check-nil, missing-parameter
  pipe.close()
  for line in value:gmatch("[^\r\n]+") do
    table.insert(items, {
      label = line,
      textEdit = {
        newText = line,
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
