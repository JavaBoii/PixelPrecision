-- Computer_1 Code

-- Configuration
local modemSide = "back" -- Adjust as needed for the wired modem
local modem = peripheral.wrap(modemSide)
local computer0Channel = 1 -- Channel to communicate with computer_0
modem.open(computer0Channel)

local incomingShellSensorSide = "right" -- Adjust as needed for the incoming shell sensor
local outgoingShellSensorSide = "left" -- Adjust as needed for the outgoing shell sensor

local incomingShellCount = 0
local outgoingShellCount = 0

-- Function to send confirmation to computer_0
local function sendConfirmation(allShellsProcessed)
    modem.transmit(computer0Channel, computer0Channel, allShellsProcessed)
end

-- Function to listen for shell passing events and count
local function countShells()
    while true do
        if redstone.getInput(incomingShellSensorSide) then
            incomingShellCount = incomingShellCount + 1
            print("Incoming shell detected. Total: " .. incomingShellCount)
            sleep(0.1) -- Prevent multiple counts for one shell
        end
        if redstone.getInput(outgoingShellSensorSide) then
            outgoingShellCount = outgoingShellCount + 1
            print("Outgoing shell detected. Total: " .. outgoingShellCount)
            sleep(0.1) -- Prevent multiple counts for one shell
        end
    end
end

-- Function to listen for start command from computer_0
local function listenForStartCommand()
    while true do
        local event, side, channelR, replyChannel, message, distance = os.pullEvent("modem_message")
        if side == modemSide and channelR == computer0Channel and message == "start_counting" then
            -- Reset counts
            incomingShellCount = 0
            outgoingShellCount = 0
            print("Received start command. Counting shells...")

            -- Start counting shells
            countShells()

            -- Send confirmation to computer_0 when all shells processed
            local allShellsProcessed = (outgoingShellCount >= shellCount)
            sendConfirmation(allShellsProcessed)
        end
    end
end

-- Start listening for start command
listenForStartCommand()
