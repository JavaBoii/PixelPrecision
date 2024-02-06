-- Computer B
-- Constants
local DISPENSE_RATE = 1.25  -- items per second
local REDSTONE_SIDE = "right"  -- Dispenser side

-- Setup
-- Define the monitor side
local monitorSide = "monitor_10"  -- Change as needed

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
modem.open(3)  -- Listen on channel 3
modem.open(101)  -- Listen on channel 101
modem.transmit(101, 101, "ItemManager online")  -- Send online status
printToMonitor("Item Dispenser online. Listening on channel 3.")

-- Function to dispense items
local function dispenseItems(amount)
    local timeToDispense = amount / DISPENSE_RATE
    redstone.setOutput(REDSTONE_SIDE, true)
    printToMonitor("Dispensing items...")
    sleep(timeToDispense)
    redstone.setOutput(REDSTONE_SIDE, false)
    printToMonitor("Dispensing complete.")
    modem.transmit(101, 101, "Dispensing complete.") -- Notify Monitoring Station
end

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if senderChannel == 3 and type(message) == "number" then
        local amount = message
        printToMonitor("Received dispensing order: " .. amount .. " items.")
        modem.transmit(4, 4, amount)  -- Notify Computer D to start counting
        modem.transmit(101, 101, "Received dispensing order: " .. amount .. " items.") -- Notify Monitoring Station
        printToMonitor("Notified Computer D to start counting.")
        modem.transmit(101, 101, "Notified Computer D to start counting.") -- Notify Monitoring Station
        dispenseItems(amount)
    end
end
