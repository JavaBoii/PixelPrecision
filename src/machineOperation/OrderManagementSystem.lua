-- Computer C
-- Setup
local monitorSide = "monitor_9"  -- Change as needed
local monitor = peripheral.wrap(monitorSide)
local modem = peripheral.wrap("top")
modem.open(1)  -- Listen on channel 1 for orders
modem.open(2)  -- Communicate with Computer A
modem.open(3)  -- Communicate with Computer B
monitor.clear()
monitor.setCursorPos(1, 1)

local function printToMonitor(text)
    local x, y = monitor.getCursorPos()
    local width, height = monitor.getSize()

    if y > height then
        monitor.scroll(1)
        monitor.setCursorPos(1, height)
    else
        monitor.setCursorPos(1, y)
    end

    monitor.write(text)
    monitor.setCursorPos(1, y + 1)
end


printToMonitor("Coordinator online. Waiting for orders on ch 1.")
modem.transmit(101, 101, "Control Center online")  -- Send online status

local orderComplete = false
local mode
local amount

-- Function to send data
local function sendData(channel, message)
    modem.transmit(channel, channel, message)
    printToMonitor("Data sent to channel " .. channel .. ": " .. tostring(message))
end

local function displayColoredText(text, color)
    monitor.setTextColor(color)
    monitor.write(text)
    monitor.setTextColor(colors.white)  -- Reset to white after printToMonitoring
end

local function getTimestamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

-- Clear the monitor and set initial cursor position
monitor.clear()
monitor.setCursorPos(1, 1)

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if senderChannel == 1 and type(message) == "table" then
        mode = message[1]
        amount = message[2]
        printToMonitor("Order received: Mode = " .. mode .. ", Amount = " .. amount)

        -- Send mode to Computer A
        sendData(2, mode)

        -- Wait for confirmation from Computer A
        repeat
            event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        until senderChannel == 2 and message == "Mode Received: " .. mode
        modem.transmit(101, 101, "Confirmation received from Computer A: " .. tostring(message)) -- Notify Monitoring Station

        -- Start item dispensing on Computer B
        sendData(3, amount)

        -- Wait for order completion from Computer D
        repeat
            event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        until senderChannel == 3 and message[1] == "order finished" and message[2] == true
        modem.transmit(101, 101, "Order completion confirmed by Computer D.") -- Notify Monitoring Station

        -- Send power down command to Computer A
        sendData(2, true)
        modem.transmit(101, 101, "Power down command sent to Computer A.") -- Notify Monitoring Station
        orderComplete = true
    end
    if orderComplete then
        local x, y = monitor.getCursorPos()
        monitor.setCursorPos(1, y)
        monitor.write("Previous order complete: " .. amount .. " shells with mode " .. mode .. " at -- ")
        displayColoredText(getTimestamp(), colors.yellow)
        monitor.setCursorPos(1, y + 2)  -- Move cursor down for the next message
        printToMonitor("Waiting for new order")
        orderComplete = false
    end
end
