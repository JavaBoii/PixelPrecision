-- Computer A
-- Setup
-- Define the monitor side
local monitorSide = "monitor_11"  -- Change as needed

-- Wrap the monitor
local monitor = peripheral.wrap(monitorSide)
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


local modem = peripheral.wrap("top")
modem.open(2)  -- Listen on channel 2
modem.open(101)  -- Listen on channel 101
modem.transmit(101, 101, "PowderChargeManager online")  -- Send online status
printToMonitor("PowerChargeManager online. Listening on channel 2.")

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if senderChannel == 2 then
        printToMonitor("Received message on channel 2: " .. tostring(message))
        local redstoneOutput = 0
        if message == 3 then
            redstoneOutput = 2
        elseif message == 2 then
            redstoneOutput = 5
        elseif message == 1 then
            redstoneOutput = 14
        end

        if redstoneOutput > 0 then
            redstone.setAnalogOutput("left", redstoneOutput)
            modem.transmit(101, 101, "RS Power " .. redstoneOutput)
            printToMonitor("Redstone output set to " .. redstoneOutput)
        else
            redstone.setAnalogOutput("left", 0)
            printToMonitor("No redstone output.")
        end
        -- Inside Computer A's main loop, after setting the redstone output
        modem.transmit(2, 2, "Mode Received: " .. message)
        printToMonitor("Confirmation sent to Computer C.")

        -- Wait for power down command
        printToMonitor("Waiting for power down command...")
        repeat
            local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        until senderChannel == 2 and message == true

        redstone.setAnalogOutput("left", 0)
        printToMonitor("Power down command received. Redstone output turned off.")
    end
    sleep(0.2)
end
