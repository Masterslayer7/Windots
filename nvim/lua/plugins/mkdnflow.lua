return {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown", "rmd" }, -- Load only for markdown files
    config = function()
        require("mkdnflow").setup({
            -- You can add custom configuration options here
        })
    end,
}
