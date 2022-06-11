if vim.b.cmp_commit_gb then
	vim.cmd("call setline(1, '" .. vim.b.cmp_commit_gb .. "')")
end

if vim.b.cmp_commit_wl then
	local file = vim.fn.expand(vim.b.cmp_commit_wl)
	vim.b.cmp_commit_wl = vim.fn.filereadable(file) == 1 and vim.fn.json_decode(vim.fn.readfile(file)) or {}
end

if vim.b.cmp_commit_rl then
	local _, gitrepo = vim.fn.getcwd():match("([^,]+)/([^,]+)")
	for _, repo in pairs(vim.b.cmp_commit_rl) do
		if gitrepo == repo[1] then
			local file = vim.fn.expand(repo[2])
			vim.b.cmp_commit_rl = vim.fn.filereadable(file) == 1 and vim.fn.json_decode(vim.fn.readfile(file)) or {}
			break
		end
	end
end
