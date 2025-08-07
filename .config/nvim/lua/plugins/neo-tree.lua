return {
  {
    "nvim-tree/nvim-web-devicons",
    config = function(_, opts)
      -- make sure we only ever match what we override
      opts.strict = true

      -- grab the SQL icon & hex‑color from its filetype
      local icons = require("nvim-web-devicons")
      local sql_icon = icons.get_icon_by_filetype("sql") or opts.default_icon
      local sql_color = icons.get_icon_color_by_filetype("sql") or opts.default_color

      -- ensure the override_by_extension table exists
      opts.override_by_extension = opts.override_by_extension or {}
      opts.override_by_extension["drift"] = {
        icon = sql_icon,
        color = sql_color,
        name = "Drift",
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["Y"] = function(state)
              -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
              -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local filename = node.name
              local modify = vim.fn.fnamemodify

              local results = {
                filepath,
                modify(filepath, ":."),
                modify(filepath, ":~"),
                filename,
                modify(filename, ":r"),
                modify(filename, ":e"),
              }

              -- absolute path to clipboard
              local i = vim.fn.inputlist({
                "Choose to copy to clipboard:",
                "1. Absolute path: " .. results[1],
                "2. Path relative to CWD: " .. results[2],
                "3. Path relative to HOME: " .. results[3],
                "4. Filename: " .. results[4],
                "5. Filename without extension: " .. results[5],
                "6. Extension of the filename: " .. results[6],
              })

              if i > 0 then
                local result = results[i]
                if not result then
                  return print("Invalid choice: " .. i)
                end
                vim.fn.setreg('"', result)
                vim.notify("Copied: " .. result)
              end
            end,
          },
          event_handlers = {
            {
              event = "file_opened",
              handler = function(file_path)
                if
                    file_path:match("%.png$")
                    or file_path:match("%.jpg$")
                    or file_path:match("%.jpeg$")
                    or file_path:match("%.gif$")
                    or file_path:match("%.webp$")
                    or file_path:match("%.avif$")
                then
                  require("image").render_image(file_path)
                end
              end,
            },
          },
        },
      })
      vim.keymap.set("n", "<leader>b", ":Neotree filesystem reveal left<CR>", { silent = true, noremap = true })
    end,
  },
}
