
local modemSide = "back" -- Adjust as needed
local modem = peripheral.wrap(modemSide)
local channel = 1 -- Same channel as the receiving computer
modem.open(channel)

-- Function to send data
local function sendData(shellPower, shellCount)
    local message = {shellPower, shellCount}
    modem.transmit(channel, channel, message)
end

-- Function to get user input
local function getUserInput(prompt)
    print(prompt)
    return tonumber(read())
end

-- Get user input for shell type and count
local shellPower = getUserInput("Enter shell type (1-4):")
local shellCount = getUserInput("Enter number of shells to process:")

-- Send the data
sendData(shellPower, shellCount)
print("Data sent: Shell Type = " .. shellPower .. ", Shell Count = " .. shellCount)

-- Wait for confirmation
local event, side, channelR, replyChannel, message, distance = os.pullEvent("modem_message")
if message == "OK" then
    print("Confirmation received: Your order is being processed.")
else
    print("No confirmation received.")
end

-- Wait for order completion
event, side, channelR, replyChannel, message, distance = os.pullEvent("modem_message")
print("Order completed: " .. message .. " shells processed.")

