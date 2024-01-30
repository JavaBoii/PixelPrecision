-- Computer D
-- Setup
local modem = peripheral.wrap("back")
modem.open(4)  -- Listen on channel 4
modem.open(101)  -- Listen on channel 101
modem.transmit(101, 101, "Safeguard online")  -- Send online status
local COUNT_SIDE = "left"  -- Counting side
local SHELL_INTERVAL = 1.50  -- Time interval between shells in seconds
print("Redstone Signal Counter online. Listening on channel 4.")

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
        modem.transmit(101, 101, "RS counting start") -- Notify Monitoring Station
        print("Starting to count redstone signals for " .. amount .. " items.")

        -- Count redstone signals
        while count < amount do
            local signalTime = waitForNextShell()
            count = count + 1
            print("Counted: " .. count)
            modem.transmit(101, 101, "Counted: " .. count) -- Notify Monitoring Station
        end

        modem.transmit(3, 3, { "order finished", true })  -- Notify Computer B
        modem.transmit(101, 101, "Order finished -> to B") -- Notify Monitoring Station
        print("Counting complete. Notifying Computer B.")
    end
end
