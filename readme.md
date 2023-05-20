🥬 codestats.nvim
=================

A simple [neovim](https://neovim.io) plugin for [Code::Stats](https://codestats.net).

## Features

- no need for Python, Lua is bundled with neovim!
- compatible with [codestats-fish](https://github.com/nyaa8/codestats-fish) and [codestats-zsh](https://gitlab.com/code-stats/code-stats-zsh) (`CODESTATS_API_KEY`)

## Requirements

- cURL
- neovim 0.5 or newer

## Installation

### [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use("mcarn/codestats.nvim")
```

### [Lazy](https://github.com/folke/lazy.nvim)
```lua
local plugins = {"mcarn/codestats.nvim"}
require("lazy").setup(plugins, opts)
```

## Configuration

Set the `CODESTATS_API_KEY` environment variable to your CodeStats token.

### Fish

```sh
set -Ux "SFMyNTY.OEotWWdnPT0jI01qaz0.X0wVEZquh8Ogau1iTtBihYqqL71FD8N6p5ChQiIpaxQ"
```

### Zsh

```sh
echo "export CODESTATS_API_KEY=SFMyNTY.OEotWWdnPT0jI01qaz0.X0wVEZquh8Ogau1iTtBihYqqL71FD8N6p5ChQiIpaxQ" >> ~/.zshenv
```

### Bash

```sh
echo "export CODESTATS_API_KEY=SFMyNTY.OEotWWdnPT0jI01qaz0.X0wVEZquh8Ogau1iTtBihYqqL71FD8N6p5ChQiIpaxQ" >> ~/.bash_profile
```

You can also set `CODESTATS_API_URL` if you want to use a different instance, eg.
```sh
set -Ux CODESTATS_API_URL "https://beta.codestats.net/api"
```

### Lualine

Call `get_codestats` in any of the sections.

```lua

local function get_codestats()
	local codestats = require("codestats")
	local exp = codestats.current_xp()
	
	return "CS::" .. tostring(exp)

end
```
