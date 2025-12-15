---
-- Pull in the wezterm API
local wezterm = require 'wezterm'
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.default_prog = {'/usr/bin/fish', '-l'}

config.font = wezterm.font("JetBrainsMono Nerd Font")
-- or, changing the font size and color scheme.
config.font_size = 14
config.color_scheme = 'Catppuccin Mocha (Gogh)'
config.colors = {
    cursor_bg = '#50FA7B',
    cursor_border = '#50FA7B'
}

local color_scheme = wezterm.color.get_builtin_schemes()[config.color_scheme] or {}

tabline.setup({
    options = {
        theme = color_scheme
    },
    extensions = {'resurrect'}
})

tabline.apply_to_config(config)
workspace_switcher.apply_to_config(config)

config.window_decorations = 'RESIZE'
config.tab_bar_at_bottom = true
config.front_end = "WebGpu"
config.prefer_egl = true
config.window_close_confirmation = "NeverPrompt"
config.show_tabs_in_tab_bar = true
config.window_decorations = "TITLE | RESIZE"

config.window_frame = {
  inactive_titlebar_bg = '#353535',
  active_titlebar_bg = '#2b2042',
  inactive_titlebar_fg = '#cccccc',
  active_titlebar_fg = '#ffffff',
  inactive_titlebar_border_bottom = '#2b2042',
  active_titlebar_border_bottom = '#2b2042',
  button_fg = '#cccccc',
  button_bg = '#2b2042',
  button_hover_fg = '#ffffff',
  button_hover_bg = '#3b3052',
}

config.keys = { -- Panel configurations
{
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.SplitHorizontal {
        domain = "CurrentPaneDomain"
    }
}, {
    key = 'k',
    mods = 'CTRL',
    action = wezterm.action.SendString 'clear\n'
}, -- Resurrect configurations
{
    key = "w",
    mods = "ALT",
    action = wezterm.action_callback(function(win, pane)
        resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
    end)
}, {
    key = "W",
    mods = "ALT",
    action = resurrect.window_state.save_window_action()
}, {
    key = "T",
    mods = "ALT|SHIFT",
    action = resurrect.tab_state.save_tab_action()
}, {
    key = "s",
    mods = "ALT",
    action = wezterm.action_callback(function(win, pane)
        resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
        resurrect.window_state.save_window_action()
    end)
}, {
    key = "r",
    mods = "ALT",
    action = wezterm.action_callback(function(win, pane)
        resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
            local type = string.match(id, "^([^/]+)") -- match before '/'
            id = string.match(id, "([^/]+)$") -- match after '/'
            id = string.match(id, "(.+)%..+$") -- remove file extention

            local opts = {
                close_open_tabs = true,
                window = pane:window(),
                on_pane_restore = resurrect.tab_state.default_on_pane_restore,
                relative = true,
                restore_text = true
            }

            if type == "workspace" then
                local state = resurrect.state_manager.load_state(id, "workspace")
                local workspace_name = state.workspace or label
                wezterm.mux.rename_workspace(pane:window():get_workspace(), workspace_name)
                resurrect.workspace_state.restore_workspace(state, opts)

                win:toast_notification("WezTerm Resurrect", "Workspace restaurado: " .. workspace_name, nil, 4000)

            elseif type == "window" then
                local state = resurrect.state_manager.load_state(id, "window")
                resurrect.window_state.restore_window(pane:window(), state, opts)
            elseif type == "tab" then
                local state = resurrect.state_manager.load_state(id, "tab")
                resurrect.tab_state.restore_tab(pane:tab(), state, opts)
            end
        end)
    end)
}, -- Workspaces configurations
{
    key = "S",
    mods = 'CTRL|SHIFT',
    action = workspace_switcher.switch_workspace()
}, {
    key = 'W',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PromptInputLine {
        description = wezterm.format {{
            Attribute = {
                Intensity = 'Bold'
            }
        }, {
            Foreground = {
                AnsiColor = 'Fuchsia'
            }
        }, {
            Text = 'Enter name for new workspace'
        }},
        action = wezterm.action_callback(function(window, pane, line)
            -- line will be `nil` if they hit escape without entering anything
            -- An empty string if they just hit enter
            -- Or the actual line of text they wrote
            if line then
                window:perform_action(wezterm.action.SwitchToWorkspace {
                    name = line
                }, pane)
            end
        end)
    }
}}

-- Finally, return the configuration to wezterm:
return config
