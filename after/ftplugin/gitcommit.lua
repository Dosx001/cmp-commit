if vim.b.cmp_commit_gb then
	vim.cmd("call setline(1, '" .. vim.b.cmp_commit_gb .. "')")
end

if vim.b.cmp_commit_wl then
	local file = vim.fn.expand(vim.b.cmp_commit_wl)
	vim.b.cmp_commit_wl = vim.fn.filereadable(file) == 1 and vim.fn.json_decode(vim.fn.readfile(file)) or {}
end

if vim.b.cmp_commit_rn then
	local _, gitrepo = vim.fn.getcwd():match("([^,]+)/([^,]+)")
	for index, repo in pairs(vim.b.cmp_commit_rn) do
		if gitrepo == repo then
			local file = vim.fn.expand(vim.b.cmp_commit_rl[index])
			vim.b.test = vim.fn.filereadable(file)
			vim.b.cmp_commit_rl = vim.fn.filereadable(file) == 1 and vim.fn.json_decode(vim.fn.readfile(file)) or {}
			break
		end
	end
end
