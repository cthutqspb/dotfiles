return {
    "atomicptr/defold.nvim",
    version = '*',  -- или latest
    lazy = false,
    opts = {
        defold = {
            set_default_editor = false,
            auto_fetch_dependencies = true,
            hot_reload_enabled = false,
        },
        debugger = { enable = false },
    }
}
