local source = {}

source.new = function()
	return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function()
	return { "*", "[", "{" }
end

source.default_config = {
	format = { "", "" },
	length = -1,
	block = "ls -RA -I.git -p | grep -v / | uniq | tail -n +3",
	word_list = {},
}

source.setup = function(config)
	if config.format and #config.format == 2 then
		source.default_config.format = config.format
	end
	if config.length and config.length > 0 then
		source.default_config.length = config.length
	end
	if config.block and type(config.block) == "table" then
		local dirs = ""
		for _, dir in pairs(config.block) do
			dirs = string.format("%s %s", dirs, string.format("-I%s", dir))
		end
		source.default_config.block = string.format(
			"%s %s %s",
			"ls -RA -I.git",
			dirs,
			"-p | grep -v / | uniq | tail -n +3"
		)
	end
	if config.word_list then
		local file = vim.fn.expand(config.word_list)
		if vim.fn.filereadable(file) == 1 then
			source.default_config.word_list = vim.fn.json_decode(vim.fn.readfile(file))
		end
	end
end

source.complete = function(self, request, callback)
	local input = string.sub(request.context.cursor_before_line, request.offset - 1)
	local items = {}
	if input == "*" then
		items = self._source(
			"git branch --show-current 2> /dev/null || git branch | grep '* ' | awk '{print $2}'",
			request,
			input
		)
	elseif input == "[" or input == "{" then
		items = self._source(source.default_config.block, request, input)
	else
		for _, word in pairs(self.default_config.word_list) do
			table.insert(items, {
				label = word,
			})
		end
	end
	callback(items)
end

source._source = function(src, request, input)
	local items = {}
	local pipe = io.popen(src)
	local value
	if pipe then
		value = input == "*"
				and string.format(
					"%s%s%s",
					source.default_config.format[1],
					pipe:read("l"),
					source.default_config.format[2]
				)
			or pipe:read("a")
		pipe:close()
	end
	for line in value:gmatch("[^\r\n]+") do
		table.insert(items, {
			label = line,
			textEdit = {
				newText = input == "{" and string.sub(line, 0, source.default_config.length) or line,
				range = {
					start = {
						line = request.context.cursor.row - 1,
						character = request.context.cursor.col - 1 - #input,
					},
					["end"] = {
						line = request.context.cursor.row - 1,
						character = request.context.cursor.col - 1,
					},
				},
			},
		})
	end
	return items
end

return source
