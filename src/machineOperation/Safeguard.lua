-- Computer D
-- Setup
-- Define the monitor side
local monitorSide = "monitor_7"  -- Change as needed

-- Wrap the monitor
local MONITOR = peripheral.wrap(monitorSide)

local MODEM = peripheral.wrap("top")
local CHANNELS = { 4, 101 }
local COUNT_SIDE = "left"  -- Counting side
local SHELL_INTERVAL = 1.50  -- Time interval between shells in seconds

for i, channel in ipairs(CHANNELS) do
    MODEM.open(channel)
end

MODEM.transmit(101, 101, "Safeguard online")  -- Send online status

MONITOR.clear()
MONITOR.setCursorPos(1, 1)

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


printToMonitor("Redstone Signal Counter online. Listening on channel 4.")

-- Function to wait for the next shell
local function waitForNextShell()
    local lastSignalTime = os.clock()
    while true do
        -- If a signal is received and the time since the last signal is greater than the interval, return the current time
        if redstone.getInput(COUNT_SIDE) and (os.clock() - lastSignalTime) >= SHELL_INTERVAL then
            return os.clock() --
        end
        sleep(0.1)
    end
end

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if senderChannel == 4 and type(message) == "number" then
        local amount = message
        local count = 0
        MODEM.transmit(101, 101, "RS counting start") -- Notify Monitoring Station
        printToMonitor("Starting to count redstone signals for " .. amount .. " items.")

        -- Count redstone signals
        while count < amount do
            local signalTime = waitForNextShell()
            count = count + 1
            printToMonitor("Counted: " .. count)
            MODEM.transmit(101, 101, "Counted: " .. count) -- Notify Monitoring Station
        end

        MODEM.transmit(3, 3, { "order finished", true })  -- Notify Computer C
        MODEM.transmit(101, 101, "Order finished -> to B") -- Notify Monitoring Station
        printToMonitor("Counting complete. Notifying Computer B.")
    end
end
