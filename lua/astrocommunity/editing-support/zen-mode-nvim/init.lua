return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      backdrop = 1,
      width = function() return math.min(120, vim.o.columns * 0.75) end,
      height = 0.9,
      options = {
        number = false,
        relativenumber = false,
        foldcolumn = "0",
        list = false,
        showbreak = "NONE",
        signcolumn = "no",
      },
    },
    plugins = {
      options = {
        cmdheight = 1,
        laststatus = 0,
      },
    },
    on_open = function() -- disable diagnostics, indent blankline, winbar, and offscreen matchup
      local astrocore_avail, astrocore = pcall(require, "astrocore")
      if astrocore_avail then
        vim.g.diagnostics_mode_old = astrocore.config.features.diagnostics_mode
        astrocore.set_diagnostics(0)
      end

      vim.g.indent_blankline_enabled_old = vim.g.indent_blankline_enabled
      vim.g.indent_blankline_enabled = false
      vim.g.miniindentscope_disable_old = vim.g.miniindentscope_disable
      vim.g.miniindentscope_disable = true

      vim.g.winbar_old = vim.o.winbar
      vim.api.nvim_create_autocmd({ "BufWinEnter", "BufNew" }, {
        pattern = "*",
        callback = function() vim.o.winbar = nil end,
        group = vim.api.nvim_create_augroup("disable_winbar", { clear = true }),
        desc = "Ensure winbar stays disabled when writing to file, switching buffers, opening floating windows, etc.",
      })

      if require("astrocore").is_available "vim-matchup" then
        vim.cmd.NoMatchParen()
        vim.g.matchup_matchparen_offscreen_old = vim.g.matchup_matchparen_offscreen
        vim.g.matchup_matchparen_offscreen = {}
        vim.cmd.DoMatchParen()
      end
    end,
    on_close = function() -- restore diagnostics, indent blankline, winbar, and offscreen matchup
      local astrocore_avail, astrocore = pcall(require, "astrocore")
      if astrocore_avail then astrocore.set_diagnostics(vim.g.diagnostics_mode_old) end

      vim.g.indent_blankline_enabled = vim.g.indent_blankline_enabled_old
      vim.g.miniindentscope_disable = vim.g.miniindentscope_disable_old
      if vim.g.indent_blankline_enabled_old then vim.cmd "IndentBlanklineRefresh" end

      vim.api.nvim_clear_autocmds { group = "disable_winbar" }
      vim.o.winbar = vim.g.winbar_old

      if require("astrocore").is_available "vim-matchup" then
        vim.g.matchup_matchparen_offscreen = vim.g.matchup_matchparen_offscreen_old
        vim.cmd.DoMatchParen()
      end
    end,
  },
}
