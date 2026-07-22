return {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown", "rmd" }, -- Load only for markdown files
    config = function()
        require("mkdnflow").setup({
            default_mappings = true,
        })
    end,
}
