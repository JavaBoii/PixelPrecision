-- Main Computer (computer_0) Code

-- Configuration
local modemSide = "back" -- Adjust as needed for the wireless modem
local modem = peripheral.wrap(modemSide)
local channel = 1 -- Channel for receiving orders
modem.open(channel)

local redstoneSide = "right" -- Adjust as needed for the redstone output
local shellCount = 0

-- Function to set redstone signal based on shell power
local function setRedstoneSignal(shellPower)
    local strength = 0
    if shellPower == 1 then strength = 11
    elseif shellPower == 2 then strength = 5
    elseif shellPower == 3 then strength = 2
    end
    redstone.setAnalogOutput("right", strength)
end

-- Function to receive and process orders
local function processOrders()
    while true do
        local event, side, channelR, replyChannel, message, distance = os.pullEvent("modem_message")
        if side == modemSide and channelR == channel then
            local shellPower, requestedCount = unpack(message)
            shellCount = requestedCount

            setRedstoneSignal(shellPower)
            print("Processing order: Shell Power = " .. shellPower .. ", Shell Count = " .. requestedCount)

            -- Dispense shells (5 redstone toggles per shell)
            for i = 1, requestedCount do
                redstone.setOutput(redstoneSide, true)
                sleep(1) -- Adjust delay as needed
                redstone.setOutput(redstoneSide, false)
                sleep(1) -- Adjust delay as needed
            end

            modem.transmit(channel, channel, "start_counting")

            -- Wait for confirmation from computer_1
            local confirmationReceived = false
            while not confirmationReceived do
                local event, side, channelR, replyChannel, message, distance = os.pullEvent("modem_message")
                if side == "left" and channelR == channel then -- Adjust 'left' as needed for the wired modem side
                    if message == true then
                        print("Order completed: " .. shellCount .. " shells processed.")
                        confirmationReceived = true
                    else
                        error("Error: Confirmation not received or processing error.")
                    end
                end
            end

            redstone.setOutput(redstoneSide, false) -- Turn off redstone signal
        end
    end
end

-- Start processing orders
processOrders()
