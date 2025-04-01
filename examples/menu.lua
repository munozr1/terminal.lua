local t = require "terminal"
local Sequence = require("terminal.sequence")


-- Key bindings for arrow keys, 'j', 'k', and Enter.
local key_names = {
  ["\27[A"] = "up", -- Up arrow key
  ["k"] = "up",     -- 'k' key
  ["\27[B"] = "down", -- Down arrow key
  ["j"] = "down",   -- 'j' key
  ["\r"] = "enter",  -- Carriage return (Enter)
  ["\n"] = "enter",  -- Newline (Enter)
}

local greenDiamond = Sequence(
  function() return t.text.stack.push_seq({ fg = "green" }) end, -- set green FG color AT TIME OF WRITING
  "◇", -- write a diamond
  t.text.stack.pop_seq -- passing in function is enough, since no parameters needed
)
local pipe= Sequence(
  function() return t.text.stack.push_seq({ fg = "white" }) end, -- set green FG color AT TIME OF WRITING
  "│", -- write a pipe
  t.text.stack.pop_seq -- passing in function is enough, since no parameters needed
)

local circle= Sequence(
  function() return t.text.stack.push_seq({ fg = "white" }) end, -- set green FG color AT TIME OF WRITING
  "○", -- write a circle
  t.text.stack.pop_seq -- passing in function is enough, since no parameters needed
)

local dot= Sequence(
  function() return t.text.stack.push_seq({ fg = "white" }) end, -- set green FG color AT TIME OF WRITING
  "●", -- write a dot
  t.text.stack.pop_seq -- passing in function is enough, since no parameters needed
)

local IMenu = {}

-- Initialize choices, cursor position, and selected option.
IMenu._choices = {} -- Array of selectable options (strings).
IMenu._choices = {}
IMenu.cursorX = 0
IMenu.cursorY = 0
IMenu.selected = nil -- The option the user selects

function IMenu:choices(chs)
  -- choices may only be strings
  for _, val in pairs(chs) do
    if type(val) ~= "string" then
      return nil, "expected choices to be string but got"..type(val).." instead"
    end
  end

  self._choices = chs
  return true, nil
end


function IMenu:readKey()
  local key = t.input.readansi(1)
  return key, key_names[key] or key
end
function IMenu:updateCursor(y, x)
  self.cursorY = y
  self.cursorX = x
  t.cursor.position.set(y, x)
end



function IMenu:handleInput()
  if #self._choices == 0 then
    return nil, "_choices empty"
  end

  self.cursorY = self.cursorY + 2                   -- Offset cursor for initial display.
  local max = self.cursorY                          -- Top boundary of selectable options.
  local min = self.cursorY + #self._choices - 1     -- Bottom boundary.
  t.cursor.position.set(self.cursorY, self.cursorX)
  local idx = 1                                     -- Index of the currently highlighted option.
  self:select(self._choices[idx])                   -- Highlight the first option.
  while true do
    self:updateCursor(self.cursorY, self.cursorX) -- Update cursor position.
    local _, keyName = self:readKey()

    if keyName == "up" and self.cursorY > max then
      self:unselect(self._choices[idx])      -- Unhighlight current option.
      self:updateCursor(self.cursorY - 1, 1) -- Move cursor up.
      idx = idx - 1                          -- Decrement option index.
      self:select(self._choices[idx])        -- Highlight new option.
    elseif keyName == "down" and self.cursorY < min then
      self:unselect(self._choices[idx])      -- Unhighlight current option.
      self:updateCursor(self.cursorY + 1, 1) -- Move cursor down.
      idx = idx + 1                          -- Increment option index.
      self:select(self._choices[idx])        -- Highlight new option.
    elseif keyName == "enter" then
      self.selected = idx                    -- Set the selected option index.
      self:updateCursor(min + 1, self.cursorX) -- Move cursor past the options.
      return self.selected                   -- Return the selected index.
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
  t.cursor.visible.set(false)           -- Hide the cursor.
  local r, c = t.cursor.position.get()  -- Get current cursor position.
  IMenu:updateCursor(r + 1, c)       -- Position cursor for prompt.
  t.output.write(pipe, "\n")
  t.output.write(greenDiamond, "  ", "Select option:", "\n") -- Display prompt message.
  for _, val in pairs(self._choices) do
    self:unselect(val)        -- Display each option initially unselected.
  end
  self:handleInput()          -- Handle user input.
  t.output.write("\n")
  t.cursor.visible.set(true)  -- Restore cursor visibility.
  t.shutdown()
  return self.selected        -- Return selected option index.
end

IMenu:choices({"Typescript", "Typescript + swc","Javascript", "Javascript + swc"})
print("selected: "..IMenu._choices[IMenu:run()])

return IMenu
