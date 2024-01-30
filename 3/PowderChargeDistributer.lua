-- Computer D
-- Setup
local modem = peripheral.wrap("back")
modem.open(4)  -- Listen on channel 4
modem.open(101)  -- Listen on channel 101
modem.transmit(101, 101, "Safeguard")  -- Send online status
local COUNT_SIDE = "left"  -- Counting side
print("Redstone Signal Counter online. Listening on channel 4.")

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
            --if the count is 0 then wait for the first shell to arrive
            if count == 0 then
                repeat
                    print("Waiting for Shells to arrive")
                    sleep(0.5)
                until redstone.getInput(COUNT_SIDE)
                print("First Shell arrived, added to count")
                print("Counted: 1")
                count = count + 1
            end
            if redstone.getInput(COUNT_SIDE) then
                count = count + 1
                print("Counted: " .. count)
                modem.transmit(101, 101, "Counted: " .. count) -- Notify Monitoring Station
            end
            sleep(0.7)  -- Debounce delay
        end

        modem.transmit(3, 3, {"order finished", true})  -- Notify Computer B
        modem.transmit(101, 101, "Order finished -> to B") -- Notify Monitoring Station
        print("Counting complete. Notifying Computer B.")
    end
end
