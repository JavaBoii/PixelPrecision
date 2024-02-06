-- Computer sender
-- Setup
local modem = peripheral.find("modem")  -- find the wireless modem
modem.open(1)  -- open channel 1, change if needed

-- Function to send data
local function sendData(mode, amount)
    local message = { mode, amount }
    modem.transmit(1, 1, message)  -- transmit on channel 1, change if needed
    print("Data sent: Mode = " .. mode .. ", Amount = " .. amount)
end

-- User input and validation
while true do
    print("Enter powder charge mode (1-4):")
    local mode = tonumber(read())
    print("Enter amount (1-400):")
    local amount = tonumber(read())

    if mode and amount and mode >= 1 and mode <= 4 and amount >= 1 and amount <= 400 then
        sendData(mode, amount)
    else
        print("Invalid input. Mode should be 1-4 and amount should be 1-400.")
    end
end
