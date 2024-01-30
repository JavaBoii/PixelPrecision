-- Setup
local modem = peripheral.wrap("back")
if not modem then
    print("No modem attached.")
    return
end
local monitor = peripheral.wrap("left")
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

-- Display initial message
displayColoredText("Monitoring Station online.", colors.green)
print(" ")

local function getTimestamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    displayColoredText(getTimestamp(), colors.yellow)
    monitor.write(": Ch(")
    displayColoredText(tostring(senderChannel), colors.yellow)
    monitor.write(") => ")
    displayColoredText(tostring(message), colors.green)
    print(".")
end
