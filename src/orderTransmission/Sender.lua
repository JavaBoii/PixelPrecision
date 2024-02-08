-- Computer sender setup
local modem = peripheral.find("modem")  -- find the wireless modem
if not modem then
    print("No modem found. Please attach a modem to use this program.")
    return
end

modem.open(1)  -- open channel 1, change if needed

-- Define color utility function
local function setColor(color)
    if term.isColor() then
        term.setTextColor(color)
    end
end

-- Function to send data
local function sendData(mode, amount)
    local message = { mode, amount }
    modem.transmit(1, 1, message)  -- transmit on channel 1, change if needed
    setColor(colors.green)
    print("Data sent successfully!")
    setColor(colors.white)
    print("Mode = " .. mode .. ", Amount = " .. amount)
end

-- Clear screen and set cursor
local function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

-- User input and validation
while true do
    clearScreen()
    setColor(colors.yellow)
    print("Shell Ordering System")
    setColor(colors.white)
    print("Enter powder charge mode (1-4):")
    setColor(colors.yellow)
    write("Input: ")
    local mode = tonumber(read())
    setColor(colors.white)
    print("Enter amount (1-500):")
    setColor(colors.yellow)
    write("Input: ")
    local amount = tonumber(read())

    if mode and amount and mode >= 1 and mode <= 4 and amount >= 1 and amount <= 500 then
        sendData(mode, amount)
    else
        setColor(colors.red)
        print("Invalid input. Mode should be 1-4 and amount should be 1-500.")
        sleep(2)  -- Give the user time to read the error before clearing the screen
    end
    setColor(colors.white)
    print("Press -> Enter <- to continue...")
    setColor(colors.yellow)
    read()
end

--TODO: Add the functionality to wait for order to complete, get an overview of the order status and cancel the order if needed. In the end give the sender the order confirmation.
