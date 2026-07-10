return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = function()
                    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
                    if is_windows then
                        if vim.fn.executable("cmake") == 1 then
                            vim.fn.system("cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release")
                        elseif vim.fn.executable("make") == 1 then
                            vim.fn.system("make")
                        elseif vim.fn.executable("gcc") == 1 then
                            vim.fn.mkdir("build", "p")
                            vim.fn.system("gcc -O3 -Wall -fpic -std=gnu99 -shared src/fzf.c -o build/libfzf.dll")
                        else
                            print("telescope-fzf-native: No compiler (cmake, make, or gcc) found in Windows path.")
                        end
                    else
                        vim.fn.system("make")
                    end
                end,
            },
        },
        keys = {
            { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Fuzzy find files (hidden)" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Fuzzy find recent files" },
            { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in CWD" },
            { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" },
            { "<leader>fd", "<cmd>TodoTelescope<cr>", desc = "Find TODO comments" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Fuzzy find buffers" },
            { "<leader>ft", "<cmd>Telescope builtin<cr>", desc = "Other pickers..." },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help tags" },
        },
        opts = function()
            local actions = require("telescope.actions")
            return {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            local ok, err = pcall(telescope.load_extension, "fzf")
            if not ok then
                vim.notify("Telescope: fzf extension not loaded (compilation might have failed). Using default sorter.", vim.log.levels.WARN)
            end
        end,
    },
}
