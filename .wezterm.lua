local wezterm = require("wezterm")

-- Check if the current pane is running Neovim
local function is_vim(pane)
  return pane:get_user_vars().IS_NVIM == "true"
end

-- Define direction mappings
local direction_keys = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
  -- reverse lookup
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

-- Define split navigation and resizing
local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- Pass the keypress through to Neovim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

return {
  color_scheme = "Dracula",
  window_decorations = "RESIZE",
  font = wezterm.font("Cascadia Code", { weight = "Bold" }),
  font_size = 18.0,
  leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 },
  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = false,
  enable_scroll_bar = true,
  keys = {
      -- Move cursor one word left (Alt + Left)
    {key="LeftArrow", mods="ALT", action=wezterm.action{SendString="\x1b[1;3D"}},

    -- Move cursor one word right (Alt + Right)
    {key="RightArrow", mods="ALT", action=wezterm.action{SendString="\x1b[1;3C"}},

    -- Leader-based navigation and pane management
    { key = "a",  mods = "LEADER|CTRL",  action = wezterm.action({ SendString = "\x01" }) },
    { key = "-",  mods = "LEADER",       action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
    { key = "\\", mods = "LEADER",       action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { key = "s",  mods = "LEADER",       action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
    { key = "v",  mods = "LEADER",       action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { key = "o",  mods = "LEADER",       action = "TogglePaneZoomState" },
    { key = "z",  mods = "LEADER",       action = "TogglePaneZoomState" },
    { key = "c",  mods = "LEADER",       action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "l",  mods = "LEADER",       action = wezterm.action.ActivateLastTab },
    { key = "H",  mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
    { key = "J",  mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
    { key = "K",  mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
    { key = "L",  mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
    { key = "1",  mods = "LEADER",       action = wezterm.action({ ActivateTab = 0 }) },
    { key = "2",  mods = "LEADER",       action = wezterm.action({ ActivateTab = 1 }) },
    { key = "3",  mods = "LEADER",       action = wezterm.action({ ActivateTab = 2 }) },
    { key = "4",  mods = "LEADER",       action = wezterm.action({ ActivateTab = 3 }) },
    { key = "5",  mods = "LEADER",       action = wezterm.action({ ActivateTab = 4 }) },
    { key = "6",  mods = "LEADER",       action = wezterm.action({ ActivateTab = 5 }) },
    { key = "7",  mods = "LEADER",       action = wezterm.action({ ActivateTab = 6 }) },
    { key = "8",  mods = "LEADER",       action = wezterm.action({ ActivateTab = 7 }) },
    { key = "9",  mods = "LEADER",       action = wezterm.action({ ActivateTab = 8 }) },
    { key = "&",  mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
    { key = "d",  mods = "LEADER",       action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
    { key = "x",  mods = "LEADER",       action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
    -- Move between split panes
    split_nav("move", "h"),
    split_nav("move", "j"),
    split_nav("move", "k"),
    split_nav("move", "l"),
    -- Resize panes
    split_nav("resize", "h"),
    split_nav("resize", "j"),
    split_nav("resize", "k"),
    split_nav("resize", "l"),
  },
}
