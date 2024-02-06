-- Computer B

-- Utility function to define color
local function setColor(color)
    if term.isColor() then
        term.setTextColor(color)
    end
end

-- Clear screen and set cursor
local function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

-- Utility function to prompt user for input
local function promptUser(prompt, color)
    setColor(color)
    print(prompt)
    setColor(colors.yellow)
    write("Input: ")
    local input = read()
    setColor(colors.white)
    print(" ")
    return input
end

-- Utility function to display colored text
local function informUser(text, color)
    setColor(color)
    print(text)
    setColor(colors.white)
end


-- Constants
local DISPENSE_RATE = 1.25  -- Predefined items per second
local REDSTONE_SIDE = "right"  -- Predefined dispenser side
local monitorSide
local monitor

local CHANNELS = { 101 ,1, 2, 3 }  -- Predefined channels

-- Setup

-- Setup monitor
monitorSide = promptUser("Enter the side or name of the monitor:", colors.yellow)
monitor = peripheral.wrap(monitorSide)
if not monitor then
    informUser("Monitor not found on " .. monitorSide .. ".", colors.red)
    return
else
    informUser("Monitor found. " .. monitorSide .. ".", colors.green)
end

-- Setup modem
local modemSide = promptUser("Enter the side of the modem:", colors.yellow)
local modem = peripheral.wrap(modemSide)
if not modem then
    informUser("No modem attached on " .. modemSide .. ".", colors.red)
    return
end

-- Channel modification utility functions
local function displayChannels()
    print("Current channels:")
    for i, channel in ipairs(CHANNELS) do
        print("[ " .. i .. " ]" .. " Channel " .. channel)
    end
end

local function changeChannel()
    clearScreen()
    displayChannels()
    local selection = tonumber(promptUser("Enter the number of the channel to change:", colors.yellow))
    if selection and CHANNELS[selection] then
        local newChannel = tonumber(promptUser("Enter new channel number:", colors.yellow))
        if newChannel then
            modem.close(CHANNELS[selection])
            CHANNELS[selection] = newChannel
            modem.open(newChannel)
            informUser("Channel changed successfully.", colors.green)
        else
            informUser("Invalid channel number.", colors.red)
        end
    else
        informUser("Invalid selection." , colors.red)
    end
end

local function deleteChannel()
    clearScreen()
    displayChannels()
    local selection = tonumber(promptUser("Enter the number of the channel to delete:", colors.red))
    if selection and CHANNELS[selection] then
        modem.close(CHANNELS[selection])
        table.remove(CHANNELS, selection)
        informUser("Channel:" .. selection, colors.red)
        informUser("deleted successfully." , colors.green)
    else
        print("Invalid selection.")
    end
end

local function addChannel()
    clearScreen()
    local newChannel = tonumber(promptUser("Enter new channel number:", colors.green))
    if newChannel then
        table.insert(CHANNELS, newChannel)
        modem.open(newChannel)
        informUser("Channel added successfully.", colors.green)
    else
        informUser("Invalid channel number.", colors.red)
    end
end

-- Main interaction loop
local changeChannels = promptUser("Do you want to change the channels? (yes/no)", colors.yellow)
if changeChannels:lower() == "yes" then
    while true do
        clearScreen()
        displayChannels()
        print("\nWhat would you like to do?")
        informUser("1. Change a channel", colors.yellow)
        informUser("2. Delete a channel", colors.red)
        informUser("3. Add a channel", colors.green)
        informUser("4. Exit configuration", colors.blue)
        local choice = promptUser("Enter your choice (1-4):", colors.white)

        if choice == "1" then
            changeChannel()
        elseif choice == "2" then
            deleteChannel()
        elseif choice == "3" then
            addChannel()
        elseif choice == "4" then
            clearScreen()
            print("Exiting channel modification...")
            break
        else
            informUser("Invalid choice. Please enter a number between 1 and 4.", colors.red)
        end
    end
end

-- Open channels
local function openChannels()
    for _, channel in ipairs(CHANNELS) do
        modem.open(channel)
    end
end

openChannels()
informUser("Channels opened successfully.", colors.green)
displayChannels()

informUser("Setup complete. Channels and Monitor are now configured.", colors.green)

sleep(1)  -- Give the user time to read the message
clearScreen()
print("ItemManager working...")

-- Utility function to print to monitor
local function printToMonitor(text)
    local x, y = monitor.getCursorPos()
    local width, height = monitor.getSize()

    if y > height then
        monitor.scroll(1)
        monitor.setCursorPos(1, height)
    else
        monitor.setCursorPos(1, y)
    end

    monitor.write(text)
    monitor.setCursorPos(1, y + 1)
end

modem.transmit(101, 101, "ItemManager online")  -- Send online status
printToMonitor("Item Dispenser online. Listening on channel 3.")

-- Function to dispense items
local function dispenseItems(amount)
    local timeToDispense = amount / DISPENSE_RATE
    redstone.setOutput(REDSTONE_SIDE, true)
    printToMonitor("Dispensing items...")
    sleep(timeToDispense)
    redstone.setOutput(REDSTONE_SIDE, false)
    printToMonitor("Dispensing complete.")
    modem.transmit(101, 101, "Dispensing complete.") -- Notify Monitoring Station
end

-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if senderChannel == 3 and type(message) == "number" then
        local amount = message
        printToMonitor("Received dispensing order: " .. amount .. " items.")
        modem.transmit(4, 4, amount)  -- Notify Computer D to start counting
        modem.transmit(101, 101, "Received dispensing order: " .. amount .. " items.") -- Notify Monitoring Station
        printToMonitor("Notified Computer D to start counting.")
        modem.transmit(101, 101, "Notified Computer D to start counting.") -- Notify Monitoring Station
        dispenseItems(amount)
    end
end
