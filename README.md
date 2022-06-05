# cmp-commit

## ⚠️ ATTENTION ⚠️

This plugin only works on Linux. I'm not smart enough to making this work on Windows and
I don't own a Mac.

## Setup

You'll only need cmp-commit to work when commiting so adding the following to your init.lua will
do just that.

```lua
cmp.setup.filetype('gitcommit', {
  sources = {
    { name = 'commit' }
  }
})
```

## Standard Config

I created cmp-commit to improve my workflow of my current job so some opitions might not be useful
but cmp-commit still might offer some useful features.

```lua
require('cmp_commit').setup({
  format = { "<<= ", " =>>" },
  length = 6,
  block = { "__pycache__", "CMakeFiles", "node_modules", "target" },
  word_list = "~/cmpcommit.json"
})
```

## Filename Auto-Completion

cmp-commit will auto-complete any filename inside your git repo. It does not matter if the file
nested in 6 directories. cmp-commit will not output the full path of the file only the filename.

### Blocking Directories from File Search

There are some cases where cmp-commit's filename auto-completion is slow. This can be solved by
blocking specify directories from the file search. For example, you might not want cmp-commit to
search through these specify directories from the following code block . By default cmp-commit does
not search through `.git`.

```lua
require('cmp_commit').setup({
  block = { "__pycache__", "CMakeFiles", "node_modules", "target" },
})
```

### Limit File Search Output Length

```lua
require('cmp_commit').setup({
  length = 6,
})
```

## Word List

```lua
require('cmp_commit').setup({
  word_list = "~/cmpcommit.json"
})
```

## Git Branch

```lua
require('cmp_commit').setup({
  format = { "<<= ", " =>>" },
})
```
