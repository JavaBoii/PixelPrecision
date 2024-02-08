-- Constants
local MONITOR

-- Utility function to display colored text
local function informUser(text, color)
    setColor(color)
    print(text)
    setColor(colors.white)
end

-- Utility function to prompt user for input
local function promptUser(prompt, color)
    setColor(color)
    print(prompt)
    setColor(colors.yellow)
    write("Input: ")
    local input = read()
    setColor(colors.white)
    print(" ")
    return input
end

-- Clear screen and set cursor
local function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

-- Clear Monitor and set cursor
local function clearMonitor()
    MONITOR.clear()
    MONITOR.setCursorPos(1, 1)
end

-- Utility function to define color
local function setColor(color)
    if term.isColor() then
        term.setTextColor(color)
    end
end

-- Utility to print to Monitors
local function printToMonitor(text)
    local x, y = MONITOR.getCursorPos()
    local width, height = MONITOR.getSize()

    if y > height then
        MONITOR.scroll(1)
        MONITOR.setCursorPos(1, height)
    else
        MONITOR.setCursorPos(1, y)
    end

    MONITOR.write(text)
    MONITOR.setCursorPos(1, y + 1)
end

--Utility to draw a line the whole width
-- Get the terminal size
local width, height = term.getSize()
-- Dynamically create a line that spans the width of the terminal when called
local line = string.rep("-", width)
