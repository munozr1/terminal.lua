local t = require "terminal"
--local Sequence = require("terminal.sequence")

-- Key bindings for arrow keys, 'j', 'k', and Enter.
local key_names = {
  ["\27[A"] = "up",  -- Up arrow key
  ["k"] = "up",      -- 'k' key
  ["\27[B"] = "down",-- Down arrow key
  ["j"] = "down",    -- 'j' key
  ["\r"] = "enter",  -- Carriage return (Enter)
  ["\n"] = "enter",  -- Newline (Enter)
}

local greenDiamond = "◇"
local pipe         = "│"
local circle       = "○"
local dot          = "●"

local IMenu = {}

-- Initialize choices, cursor position, and selected option.
IMenu._choices = {} -- Array of selectable options (strings).
IMenu.selected = nil -- The option the user selects

function IMenu:__template()
    local menu = greenDiamond .. "  Select an option:\n"
    for _, option in pairs(self._choices) do
        menu = menu .. pipe .. "    " .. circle .. " " .. option .. "\n"
    end
    t.text.stack.push{ -- Dim the text color.
        fg = "white",
        brightness = "dim",
    }
    print(menu)
    t.text.stack.pop()
end

function IMenu:choices(chs)
    -- choices may only be strings
    for _, val in pairs(chs) do
        if type(val) ~= "string" then
            return nil, "expected choices to be string but got" .. type(val) .. " instead"
        end
    end

    self._choices = chs
    return true, nil
end

function IMenu:readKey()
    local key = t.input.readansi(1)
    return key, key_names[key] or key
end

function IMenu:handleInput()
    if #self._choices == 0 then
        return nil, "_choices empty"
    end

    local max = #self._choices
    local min = 1
    local idx = 1                                    -- Index of the currently highlighted option.
    t.cursor.position.up(max+1)                         -- Offset cursor for initial display.
    self:select(self._choices[1])                   -- Highlight the first option.
    t.cursor.position.up(1)                         -- Offset cursor for initial display.
    while true do
        local  _, keyName = self:readKey()

        if keyName == "up" and idx > min then
            self:unselect(self._choices[idx])
            t.cursor.position.up(2)                     -- Move cursor up.
            idx = idx - 1                                -- Decrement option index.
            self:select(self._choices[idx])
            t.cursor.position.up(1)                     -- Move cursor up.
        elseif keyName == "down" and idx < max then
            self:unselect(self._choices[idx])
            --t.cursor.position.down(1)                   -- Move cursor down.
            idx = idx + 1                                -- Increment option index.
            self:select(self._choices[idx])
            t.cursor.position.up(1)                   -- Move cursor down.
        elseif keyName == "enter" then
            self.selected = idx                            -- Set the selected option index.
            t.cursor.position.down(max - idx+1)             -- Move cursor past the options.
            return self.selected                            -- Return the selected index.
        end
    end
end

-- Displays an unselected option.
-- @param string : the option name you want to unselect
function IMenu:unselect(opt)
    t.text.stack.push{ -- Dim the text color.
        fg = "white",
        brightness = "dim",
    }
    t.output.write(pipe, "    ", circle, " ", opt, "\n")
    t.text.stack.pop() -- Restore text color.
end

-- Displays a selected option.
-- @param string : the option name you want to select
function IMenu:select(opt)
    t.output.write(pipe, "    ", dot, " ", opt, "\n")
end

-- Runs the prompt and returns the selected option index.
function IMenu:run()
    t.initialize()
    t.cursor.visible.set(false)                     -- Hide the cursor.
    self:__template()
    self:handleInput()                               -- Handle user input.
    t.output.write("\n")
    t.cursor.visible.set(true)                       -- Restore cursor visibility.
    t.shutdown()
    return self.selected                              -- Return selected option index.
end

IMenu:choices({"Typescript", "Typescript + swc", "Javascript", "Javascript + swc"})
print("selected: "..IMenu._choices[IMenu:run()])

return IMenu
