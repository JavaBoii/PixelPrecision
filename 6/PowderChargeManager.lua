-- Computer A
-- Setup
local modem = peripheral.wrap("top")
modem.open(2)  -- Listen on channel 2
modem.open(101)  -- Listen on channel 101
modem.transmit(101, 101, "PowderChargeManager")  -- Send online status
print("PowerChargeManager online. Listening on channel 2.")

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if senderChannel == 2 then
        print("Received message on channel 2: " .. tostring(message))
        local redstoneOutput = 0
        if message == 3 then redstoneOutput = 2
        elseif message == 2 then redstoneOutput = 5
        elseif message == 1 then redstoneOutput = 13
        end

        if redstoneOutput > 0 then
            redstone.setAnalogOutput("left", redstoneOutput)
            modem.transmit(101, 101, "RS Power " .. redstoneOutput)
            print("Redstone output set to " .. redstoneOutput)
        else
            redstone.setAnalogOutput("left", 0)
            print("No redstone output.")
        end
        -- Inside Computer A's main loop, after setting the redstone output
        modem.transmit(2, 2, "Mode Received: " .. message)
        print("Confirmation sent to Computer C.")

        -- Wait for power down command
        print("Waiting for power down command...")
        repeat
            local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        until senderChannel == 2 and message == true

        redstone.setAnalogOutput("left", 0)
        print("Power down command received. Redstone output turned off.")
    end
    sleep(0.2)
end
