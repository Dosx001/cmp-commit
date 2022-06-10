local file = vim.fn.expand(vim.b.cmp_commit_wl)
vim.b.cmp_commit_wl = vim.fn.filereadable(file) == 1 and vim.fn.json_decode(vim.fn.readfile(file)) or {}

if vim.b.cmp_commit_gb then
	print("why", vim.bo.filetype)
	vim.cmd("call setline(1, '" .. vim.b.cmp_commit_gb .. "')")
end
