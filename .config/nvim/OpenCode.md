# OpenCode.md for nvim config

## Commands
- No build/test system detected (vim config)
- Format Lua: stylua (configured with none-ls)
- Format JS/TS: prettier (auto-detects config via none-ls)
- Treesitter plugin update: `:TSUpdate`
- Run single formatter: use vim keybinding `<leader>gf`

## Code Style
- Use 2 space indentation (see vim-options.lua)
- Use local variables via `local foo = ...`
- Import modules with `local mod = require("mod")`
- Prefer named config tables and explicit option lists
- Plugin configs use `return {}` with opts/config/functions in table style
- For error handling, use diagnostic pattern as seen in lsp-config.lua
- Consistent naming: kebab-case for plugin files, camelCase for config keys, snake_case for variables
- Prefer explicit setup/init functions for plugin config
- Do not use global variables unless necessary
- Use descriptive keymaps (see vim-options.lua)
- Add dependencies using dependencies/ensure_installed in plugin config
- Prefer inline setup (minimal comments)
- Use builtin formatters (`null_ls.builtins`) for formatting
- Avoid unused code or trailing whitespace

## Misc
- This config does not support test running (configs only)
- No Cursor/Copilot rules detected
