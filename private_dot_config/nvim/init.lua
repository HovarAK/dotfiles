-- ~/.config/nvim/init.lua
-- Option A: run nvim inside toolbox so all tools are on PATH.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    end
    vim.opt.rtp:prepend(lazypath)

    -- Basics
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.termguicolors = true

    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.smartindent = true

    vim.opt.clipboard = "unnamedplus"
    vim.opt.updatetime = 250
    vim.opt.signcolumn = "yes"
    vim.opt.cursorline = true
    vim.opt.splitright = true
    vim.opt.splitbelow = true

    -- Ensure user-local tools are on PATH (toolbox-friendly)
    vim.env.PATH = vim.fn.expand("~/.local/share/npm/bin") .. ":" .. vim.env.PATH

    -- Plugins
    require("lazy").setup("plugins", {
        rocks = { enabled = false },
    })

    -- Formatting (conform)
    require("format")

    -- Keymaps (Telescope/Oil)
    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Explorer (Oil)" })

    vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ lsp_fallback = true })
    end, { desc = "Format buffer" })

    -- LSP (Neovim 0.11+ built-in)
    -- These names must match built-in server configs.
    -- If any name fails, run: :lua print(vim.inspect(vim.lsp.configs))
    vim.lsp.config("pyright", {})
    vim.lsp.config("clangd", {})
    vim.lsp.config("html", {})
    vim.lsp.config("cssls", {})
    vim.lsp.config("ts_ls", {})      -- typescript-language-server
    vim.lsp.config("eslint", {})     -- vscode-eslint-language-server
    vim.lsp.config("jsonls", {})
    vim.lsp.config("sqls", {})       -- if you later install sqls (optional)
    vim.lsp.config("r_language_server", {}) -- R package: languageserver

    vim.lsp.enable({
        "pyright",
        "clangd",
        "html",
        "cssls",
        "ts_ls",
        "eslint",
        "jsonls",
        "r_language_server",
        -- "sqls", -- enable if you install sqls (see note below)
    })

    -- LSP keymaps
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, { desc = "Diagnostics float" })
