# cmp-commit

## ⚠️ ATTENTION ⚠️

This plugin only works on Linux.

You might get this plugin working on other systems if you use Git Bash, WSL, Cygwin, or MSYS2.

## Installation

[vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug "hrsh7th/nvim-cmp"
Plug "Dosx001/cmp-commit"
```

[packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({"Dosx001/cmp-commit", requires = "hrsh7th/nvim-cmp"})
```

## Setup

You'll only need cmp-commit to work when commiting so adding the following to your init.lua will
do just that.

```lua
local cmp = require("cmp")

cmp.setup.filetype('gitcommit', {
  sources = {
    { name = 'commit' }
  }
})
```

Also make NeoVim is your editor for git. Run the following command to setup that up.

```bash
git config --global core.editor nvim
```

## Standard Config

I created cmp-commit to improve my workflow of my current job so some opitions might not be useful
but cmp-commit still offers some useful features.

```lua
require('cmp_commit').setup({
  set = true,
  format = { "<<= ", " =>>" },
  length = 9,
  block = { "__pycache__", "CMakeFiles", "node_modules", "target" },
  word_list = "~/cmpcommit.json"
})
```

## Filename Auto-Completion

cmp-commit will auto-complete any filename inside your git repo. It does not matter if the file is
nested in multiple directories. cmp-commit will not output the full path of the file only the
filename.

In order to trigger filename auto-completion have to press `[`. This helps prevent cmp-commit
from cluttering your normal auto-completion as the auto-completion of filenames can be massive in
big projects.

### Blocking Directories from File Search

There are some cases where cmp-commit's filename auto-completion is slow. This can be solved by
blocking specify directories from the file search. For example, you might not want cmp-commit to
search through these specify directories from the following code block. By default cmp-commit does
not search through `.git`.

```lua
require('cmp_commit').setup({
  block = { "__pycache__", "CMakeFiles", "node_modules", "target" },
})
```

### Limit File Search Output Length

cmp-commit allows you to limit the number of characters by some positive integer. This can help you
referencing files with long names. This will change the behavior of the `[`. If you want to
reference a file with its full name press `{` to revert back to normal filename
auto-completion behavior.

```lua
require('cmp_commit').setup({
  length = 9,
})
```

## Word List

With cmp-commit you can create your own custom word list and cmp-commit will auto-complete as you
type. To enable this feature you must provide cmp-commit with the path and filename of your word
list as shown in the following code block. This file must be a json file and the contents of this
file must be array of strings. The file can be named whatever you like.

I recommend creating a new git repo to storage your word list and sharing it with your coworkers.

```lua
require('cmp_commit').setup({
  word_list = "PATH/TO/FILE.json"
})
```

## Git Branch

cmp-commit can auto-complete your current branch by pressing `*`. You can format this ouput using
following code block. `format` must be an array of length 2 with strings. The following settings
will output `<<= branch_name =>>`.

If you're using GitHub or GitLab this feature doesn't seem all that useful but if your using
Bitbucket and Jira then this can be pretty useful.

```lua
require('cmp_commit').setup({
  format = { "<<= ", " =>>" },
})
```

You can let cmp-commit automatically print the git branch by having the following code block.

```lua
require('cmp_commit').setup({
  set = true,
})
```
