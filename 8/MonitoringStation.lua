-- MonitoringStation.lua
-- Setup
local monitorSide = "monitor_8"  -- Change as needed
local monitor = peripheral.wrap(monitorSide)
local modem = peripheral.wrap("back")

if not modem then
    print("No modem attached.")
    return
end

monitor.clear()
modem.open(1)
modem.open(2)
modem.open(3)
modem.open(101)

local function displayColoredText(text, color)
    monitor.setTextColor(color)
    monitor.write(text)
    monitor.setTextColor(colors.white)  -- Reset to white after printing
end

local function getTimestamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

-- Function to handle scrolling and printing
local function printToMonitor(text)
    local width, height = monitor.getSize()
    local x, y = monitor.getCursorPos()

    -- Check if we need to scroll
    if y > height then
        monitor.scroll(1)
        y = height
    end

    monitor.setCursorPos(1, y)
    monitor.write(text)

    -- Move cursor to the next line, or scroll if at the bottom
    if y < height then
        monitor.setCursorPos(1, y + 1)
    else
        monitor.scroll(1)
        monitor.setCursorPos(1, height)
    end
end

-- Display initial message
printToMonitor("Monitoring Station online\n")

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    displayColoredText(getTimestamp(), colors.yellow)
    monitor.write(": Ch(")
    displayColoredText(tostring(senderChannel), colors.yellow)
    monitor.write(") => ")
    displayColoredText(tostring(message), colors.green)
    printToMonitor("\n")  -- Move cursor to the next line and handle scrolling
end
