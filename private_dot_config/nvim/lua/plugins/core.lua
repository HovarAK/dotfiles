return {

    ------------------------------------------------------------------
    -- COLORS
    ------------------------------------------------------------------
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
        require("nightfox").setup(opts)
        vim.cmd.colorscheme("nordfox")
        end,
    },

    ------------------------------------------------------------------
    -- TREESITTER (lazy + idiomatic)
    ------------------------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = {
                "lua", "vim", "vimdoc",
                "rust", "typescript", "javascript",
                "json", "bash",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
    },

    ------------------------------------------------------------------
    -- TELESCOPE (lazy command load)
    ------------------------------------------------------------------
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    ------------------------------------------------------------------
    -- FILE EXPLORER
    ------------------------------------------------------------------
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        opts = {},
    },

    ------------------------------------------------------------------
    -- GIT SIGNS
    ------------------------------------------------------------------
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {},
    },

    ------------------------------------------------------------------
    -- STATUSLINE
    ------------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "auto",
                globalstatus = true,
            },
        },
    },

    ------------------------------------------------------------------
    -- WHICH KEY
    ------------------------------------------------------------------
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },

    ------------------------------------------------------------------
    -- COMMENTS
    ------------------------------------------------------------------
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        opts = {},
    },

    ------------------------------------------------------------------
    -- LSP (Neovim 0.11+ native API)
    ------------------------------------------------------------------
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()

        -- Lua
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        })

        -- Rust
        vim.lsp.config("rust_analyzer", {})

        -- TypeScript / JavaScript
        vim.lsp.config("tsserver", {})

        vim.lsp.enable({
            "lua_ls",
            "rust_analyzer",
            "tsserver",
        })

        vim.diagnostic.config({
            float = { border = "rounded" },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })
        end,
    },

    ------------------------------------------------------------------
    -- FORMATTER
    ------------------------------------------------------------------
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = {
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                lua = { "stylua" },
                rust = { "rustfmt" },
                javascript = { "prettier" },
                typescript = { "prettier" },
            },
        },
    },

    ------------------------------------------------------------------
    -- AUTOCOMPLETION (BLINK)
    ------------------------------------------------------------------
    {
        "saghen/blink.cmp",
        version = "1.*",
        event = "InsertEnter",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
            keymap = { preset = "super-tab" },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                menu = { auto_show = true },
                documentation = { auto_show = true },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            fuzzy = {
                implementation = "prefer_rust_with_warning",
            },
        },
        opts_extend = { "sources.default" },
    },

    ------------------------------------------------------------------
    -- AUTOPAIRS (safe Blink integration)
    ------------------------------------------------------------------
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            enable_check_bracket_line = false,
            disable_filetype = { "TelescopePrompt" },
            fast_wrap = {},
        },
        config = function(_, opts)
        local autopairs = require("nvim-autopairs")
        autopairs.setup(opts)

        local ok, blink = pcall(require, "blink.cmp")
        if ok then
            local cmp_autopairs =
            require("nvim-autopairs.completion.cmp")
            blink.event:on("confirm_done",
                           cmp_autopairs.on_confirm_done())
            end
            end,
    },

    ------------------------------------------------------------------
    -- SMOOTH SCROLL
    ------------------------------------------------------------------
    {
        "karb94/neoscroll.nvim",
        keys = {
            "<C-u>", "<C-d>",
            "<C-b>", "<C-f>",
            "<C-y>", "<C-e>",
            "zt", "zz", "zb",
        },
        opts = {
            hide_cursor = true,
            stop_eof = true,
            cursor_scrolls_alone = true,
            easing_function = "sine",
            duration_multiplier = 0.6,
        },
    },
}
