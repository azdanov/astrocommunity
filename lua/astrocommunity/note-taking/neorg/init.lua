return {
  "nvim-neorg/neorg",
  version = "^8",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.keybinds"] = {}, -- Adds default keybindings
        ["core.completion"] = {
          config = {
            engine = (astrocore.is_available "nvim-cmp" and "nvim-cmp")
              or (astrocore.is_available "coq_nvim" and "coq_nvim")
              or (astrocore.is_available "nvim-compe" and "nvim-compe"),
          },
        }, -- Enables support for completion plugins
        ["core.journal"] = {}, -- Enables support for the journal module
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/projects/notes",
            },
            default_workspace = "notes",
          },
        },
      },
    })
  end,
}
