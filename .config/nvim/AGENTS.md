# Neovim Configuration Guide for AI Agents

This document helps AI models understand and work with this Neovim configuration.

## Directory Structure

```
.config/nvim/
├── init.lua                 # Entry point - bootstraps lazy.nvim, loads vim-options
├── lazy-lock.json           # Plugin version lock file
├── cspell.json              # Spell checking dictionary
├── db_ui/connections.json   # Database UI saved connections
└── lua/
    ├── vim-options.lua      # Core settings, keybindings, leader key
    └── plugins/             # One file per plugin (lazy.nvim spec format)
```

## Key Facts

- **Plugin Manager**: lazy.nvim (auto-bootstraps if missing)
- **Leader Key**: `<Space>`
- **Local Leader**: `\`
- **Color Scheme**: Catppuccin Mocha
- **Tab Width**: 2 spaces (expandtab)
- **Line Numbers**: Relative

## Plugin Configuration Pattern

Each file in `lua/plugins/` returns a lazy.nvim plugin spec table:

```lua
return {
  "author/plugin-name",
  dependencies = { ... },
  config = function()
    -- setup code
  end,
}
```

## Important Plugins & Their Files

| Plugin | File | Purpose |
|--------|------|---------|
| LSP servers | `lsp-config.lua` | Language server setup via mason |
| Completion | `completions.lua` | nvim-cmp with multiple sources |
| File browser | `neo-tree.lua` | File explorer (`<leader>b`) |
| Fuzzy finder | `telescope.lua` | Find files/grep (`<leader>ff`, `<leader>fg`) |
| Formatting | `none-ls.lua` | prettier, stylua, yamlfmt |
| Git | `gitsigns.lua`, `diffview.lua` | Git integration |
| AI completion | `completions.lua` | Supermaven (`<C-k>` to accept) |
| AI assistant | `opencode.lua` | opencode.nvim integration |
| Database | `dadbod.lua` | SQL client (`<leader>db`) |

## LSP Configuration Notes

The `lsp-config.lua` file handles TypeScript/Deno conflict:

- **ts_ls**: Only activates if NO `deno.json` exists in project
- **denols**: Only activates if `deno.json` EXISTS in project
- **eslint**: Disabled in Deno projects

Configured LSP servers: `lua_ls`, `ts_ls`, `jsonls`, `clangd`, `denols`, `eslint`, `gopls`, `pyright`

## Common Keybindings

| Keybind | Action |
|---------|--------|
| `<leader>b` | Toggle file browser |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>ca` | Code actions |
| `<leader>gf` | Format buffer |
| `<leader>gb` | Toggle git blame |
| `<leader>do` | Open diff vs main |
| `<leader>db` | Open database UI |
| `<leader>?` | Show all keybindings (which-key) |
| `K` | Hover documentation |
| `gd` | Go to definition |
| `<C-h/j/k/l>` | Navigate splits (tmux-aware) |

**Note**: which-key (`lua/plugins/which-key.lua`) displays all keybindings. When adding new leader-prefixed keybindings, consider updating which-key configuration to keep the help display accurate.

## Custom Filetypes

- `.drift` files are treated as SQL (for database migrations)

## When Making Changes

1. **Adding a plugin**: Create new file in `lua/plugins/` with lazy.nvim spec
2. **Changing keybindings**: Most are in their respective plugin file; core ones in `vim-options.lua`
3. **Adding LSP server**: Modify `lsp-config.lua` - add to mason-lspconfig ensure_installed list
4. **Adding formatter**: Modify `none-ls.lua` - add to sources and mason-null-ls ensure_installed

## Formatting Behavior

- YAML files auto-format on save
- Formatter priority: `prettierd > prettier > yamlfmt`
- Prettier respects project `.prettierrc` via `--config-precedence prefer-file`

## Dependencies

This config assumes:
- Neovim 0.9+
- Node.js (for LSP servers and prettier)
- ripgrep (for telescope live grep)
- A Nerd Font (for icons)
- Kitty terminal or tmux (for image preview and navigation)
