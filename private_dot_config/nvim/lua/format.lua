local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        python = { "isort", "black" },

        c = { "clang_format" },
        cpp = { "clang_format" },

        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },

        sql = { "sql_formatter" },
        r = { "styler" },

        lua = { "stylua" }, -- optional (only if you install stylua)
    },

    format_on_save = {
        timeout_ms = 1500,
        lsp_fallback = true,
    },
})

-- sql-formatter (npm)
conform.formatters.sql_formatter = {
    command = "sql-formatter",
    args = { "--language", "sql" },
    stdin = true,
}

-- R styler (R package)
conform.formatters.styler = {
    command = "Rscript",
    args = {
        "-e",
        "styler::style_file(commandArgs(trailingOnly=TRUE)[1])",
        "--args",
        "$FILENAME",
    },
    stdin = false,
}
