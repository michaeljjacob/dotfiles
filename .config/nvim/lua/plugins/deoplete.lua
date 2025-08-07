return {
    {
        "deoplete-plugins/deoplete-clang",
        dependencies = {
            "Shougo/deoplete.nvim",
            "roxma/nvim-yarp",
            "roxma/vim-hug-neovim-rpc",
            "zchee/libclang-python3",
        },
        config = function()
            vim.g["deoplete#sources#clang#libclang_path"] = "/Library/Developer/CommandLineTools/usr/lib/libclang.dylib"
        end,
    },
}
