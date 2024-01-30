-- Computer B
-- Constants
local DISPENSE_RATE = 1.25  -- items per second
local REDSTONE_SIDE = "right"  -- Dispenser side

-- Setup
local modem = peripheral.wrap("back")
modem.open(3)  -- Listen on channel 3
modem.open(101)  -- Listen on channel 101
modem.transmit(101, 101, "ItemManager online")  -- Send online status
print("Item Dispenser online. Listening on channel 3.")

-- Function to dispense items
local function dispenseItems(amount)
    local timeToDispense = amount / DISPENSE_RATE
    redstone.setOutput(REDSTONE_SIDE, true)
    print("Dispensing items...")
    sleep(timeToDispense)
    redstone.setOutput(REDSTONE_SIDE, false)
    print("Dispensing complete.")
    modem.transmit(101, 101, "Dispensing complete.") -- Notify Monitoring Station
end

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if senderChannel == 3 and type(message) == "number" then
        local amount = message
        print("Received dispensing order: " .. amount .. " items.")
        modem.transmit(4, 4, amount)  -- Notify Computer D to start counting
        modem.transmit(101, 101, "Received dispensing order: " .. amount .. " items.") -- Notify Monitoring Station
        print("Notified Computer D to start counting.")
        modem.transmit(101, 101, "Notified Computer D to start counting.") -- Notify Monitoring Station
        dispenseItems(amount)
    end
end
