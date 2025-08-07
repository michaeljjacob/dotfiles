# CRUSH.md

## Commands

- **Setup:**
  ./install.sh
  # This sets up submodules and symlinks config files.

- **Test:**
  tmux/test: ./tmux/run_tests.sh
  tmux/plugins/tpm/test: ./tmux/plugins/tpm/tests/test_plugin_installation.sh

- **Lint:**
  tmux: shellcheck tmux/*.sh
  tmux/plugins/tpm: shellcheck .tmux/plugins/tpm/scripts/*.sh

- **One test:**
  Run via bash: ./tmux/plugins/tpm/tests/<name>.sh

## Code Style

- **Bash scripts**: POSIX shell; prefer functions; consistent indentation (2 spaces); use `set -euo pipefail` for safety.
- **Lua**: Consistent 2 spaces, snake_case for file/module/variable names except for plugin configs.
- **Imports**: For Lua, group `require` at top; relative where possible. For bash, load helpers at top.
- **Naming**: Use descriptive snake_case for variables/functions; ALL CAPS for constants in bash.
- **Formatting**: No trailing whitespace; files end with newline.
- **Types**: Lua—prefer explicit type annotation in comments if value not obvious.
- **Error Handling**: Always check command/script exit codes; bail out early if ENV not set.
- **Plugins/Modules**: Place in their respective `/plugins/` or `/status/` or `/themes/` folders. README/CONTRIBUTING explained per-area.
- **Comments**: Minimal, purpose-driven (not restating code). Use block doc only at file/function top if needed.

## Misc

- No Cursor or Copilot rules detected.
- .crush directory is gitignored.

# End
