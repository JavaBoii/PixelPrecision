-- Computer C
-- Setup
local modem = peripheral.wrap("back")
local monitor = peripheral.wrap("left")
modem.open(1)  -- Listen on channel 1 for orders
modem.open(2)  -- Communicate with Computer A
modem.open(3)  -- Communicate with Computer B
print("Coordinator online. Waiting for orders on ch 1.")
modem.transmit(101, 101, "Controll Center")  -- Send online status

local orderComplete = false
local mode
local amount

-- Function to send data
local function sendData(channel, message)
    modem.transmit(channel, channel, message)
    print("Data sent to channel " .. channel .. ": " .. tostring(message))
end

local function displayColoredText(text, color)
    monitor.setTextColor(color)
    monitor.write(text)
    monitor.setTextColor(colors.white)  -- Reset to white after printing
end

local function getTimestamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if senderChannel == 1 and type(message) == "table" then
        mode = message[1]
        amount = message[2]
        print("Order received: Mode = " .. mode .. ", Amount = " .. amount)

        -- Send mode to Computer A
        sendData(2, mode)

        -- Wait for confirmation from Computer A
        repeat
            local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        until senderChannel == 2 and message == "Mode Received: " .. mode
        modem.transmit(101, 101, "Confirmation received from Computer A: " .. tostring(message)) -- Notify Monitoring Station

        -- Start item dispensing on Computer B
        sendData(3, amount)

        -- Wait for order completion from Computer D
        repeat
            local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        until senderChannel == 3 and message[1] == "order finished" and message[2] == true
        modem.transmit(101, 101, "Order completion confirmed by Computer D.") -- Notify Monitoring Station

        -- Send power down command to Computer A
        sendData(2, true)
        modem.transmit(101, 101, "Power down command sent to Computer A.") -- Notify Monitoring Station
        orderComplete = true
    end
    if orderComplete then
        print("previous order complete: " .. amount .. " shells with mode " .. mode)
        monitor.write("at -- ")
        displayColoredText(tostring(getTimestamp()), colors.yellow)
        print(" -- ")
        print(" ")
        print("Waiting for new order")
        orderComplete = false
    end
end
