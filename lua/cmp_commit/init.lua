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
	branch = "git branch --show-current 2> /dev/null || git branch | grep '* ' | awk '{print $2}'",
}

source.setup = function(config)
	if config.format and #config.format == 2 then
		source.default_config.format = config.format
	end
	if config.set then
		vim.b.cmp_commit_gb = source._pipe(source.default_config.branch, "*")
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
		vim.b.cmp_commit_wl = config.word_list
	end
	if config.repo_list and type(config.repo_list) == "table" then
		vim.b.cmp_commit_rl = config.repo_list
	end
end

source.complete = function(self, request, callback)
	local input = string.sub(request.context.cursor_before_line, request.offset - 1)
	local items = {}
	if input == "*" then
		items = self._source(self.default_config.branch, request, input)
	elseif input == "[" or input == "{" then
		items = self._source(source.default_config.block, request, input)
	else
		for _, list in pairs({ vim.b.cmp_commit_rl, vim.b.cmp_commit_wl }) do
			for _, line in pairs(list) do
				if type(line) == "table" then
					for label, text in pairs(line) do
						source._table(items, request, input, label, text)
					end
				else
					source._table(items, request, input, line, line)
				end
			end
		end
	end
	callback(items)
end

source._table = function(tab, request, input, label, text)
	local offset = 0
	if string.find("*[{", input, 1, true) or request.context.cursor.col == 2 then
		offset = 1
	end
	table.insert(tab, {
		label = label,
		textEdit = {
			newText = input == "[" and string.sub(text, 0, source.default_config.length) or text,
			range = {
				start = {
					line = request.context.cursor.row - 1,
					character = request.context.cursor.col - offset - #input,
				},
				["end"] = {
					line = request.context.cursor.row - 1,
					character = request.context.cursor.col,
				},
			},
		},
	})
end

source._pipe = function(src, input)
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
	return value
end

source._source = function(src, request, input)
	local value = source._pipe(src, input)
	local items = {}
	for line in value:gmatch("[^\r\n]+") do
		source._table(items, request, input, line, line)
	end
	return items
end

return source
