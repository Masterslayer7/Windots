return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- Will be mocked by mini.icons
    },
    event = "VeryLazy",
    keys = {
        { "H", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
        { "L", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
        { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin buffer" },
        { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close non-pinned buffers" },
        { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
        { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
        { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
    },
    opts = {
        options = {
            mode = "buffers",
            separator_style = "thin",
            show_buffer_close_icons = false,
            show_close_icon = false,
            always_show_bufferline = true,
            diagnostics = "nvim_lsp",
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "File Explorer",
                    text_align = "left",
                    separator = true,
                },
            },
        },
    },
}
