

local _S = {
    ['theme']           = "monad_clone", -- filename in custom_themes
    ['colour_scheme']   = "mariner_blue", -- filename in colourschemes
    ['taskbar_style']   = "full", -- "icons", "full"
    ['show_titlebars']  = false,
    ['tag_names']       = { "M", "W", "C", "T", "5", "6", "7" },
    -- ['tag_names']       = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 " },
    -- ['tag_names']       = { "1", "2", "3", "4", "5", "6", "7" },
    ['modkey']          = "Mod4",
    ['terminal']        = "x-terminal-emulator", -- GNOME : hand off to the system set list, $ 'sudo update-alternatives --config x-terminal-emulator' to edit
    ['editor']          = os.getenv("EDITOR") or "vim",
}

_S.editor_cmd = _S.terminal .. " -e " .. _S.editor

return _S
