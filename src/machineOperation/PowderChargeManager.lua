-- Computer A
--------------------------------------------------------------------------------------------------------------
-- Constants

-- Setup Constants
local TASKS = 3  -- Total number of tasks, adjust as necessary
local MONITORSIDE
local MONITOR
local MODEMSIDE = "top"
local MODEM

local CHANNELS = { 101, 2 }  -- Predefined channels
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
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

-- Clear Monitor and prepare for setup
local function clearSetupScreen()
    term.clear()
    term.setCursorPos(1, 2)  -- Start from line 2 to leave space for the loading bar
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

-- Utility function to draw a line with a specific background color
local function drawLine(x, y, length, color)
    local oldBgColor = term.getBackgroundColor()  -- Gets the current background color
    term.setBackgroundColor(color)  -- Set the background color to the specified color
    for i = x, x + length - 1 do
        -- Starts a for loop for the length of the bar
        term.setCursorPos(i, y)  -- Set the cursor position to i, y
        term.write(" ")  -- Write a space to draw the color
    end
    term.setBackgroundColor(oldBgColor)  -- Reset the background color to its original
end

-- Function to update and display the loading bar
local function updateLoadingBar(currentTask)
    local width, _ = term.getSize()
    local progress = currentTask / TASKS
    local coloredLength = math.floor(progress * width)
    local barLength = width  -- Total length of the bar, leaving space for brackets
    local startX = 1  -- Start drawing from the first character to leave space for the left bracket
    local y = 1  -- Draw on the first line

    -- Draw the background part of the bar in dark gray
    drawLine(startX, y, barLength, colors.gray)

    -- Determine the color based on progress
    local fillColor = progress < 1 and colors.yellow or colors.green

    -- Draw the filled part of the bar
    drawLine(startX, y, coloredLength, fillColor)

    -- Calculate percentage and position for the percentage text
    local percentage = math.floor(progress * 100)
    local percentageText = percentage .. "%"
    local percentagePos = math.floor((width / 2) - (#percentageText / 2))

    -- Write percentage text. Temporarily change background color to ensure visibility.
    term.setCursorPos(percentagePos, y)
    term.setBackgroundColor(fillColor)  -- Ensure the percentage is visible on the bar
    term.write(percentageText)

    -- Reset cursor position and background color
    term.setCursorPos(1, 2)  -- Move cursor down after drawing the bar
    term.setBackgroundColor(colors.black)  -- Reset background color
end

-- Function to detect and choose a monitor
local function chooseMonitor()
    local sides = { "left", "right", "top", "bottom", "back", "front", "monitor_0", "monitor_1", "monitor_2", "monitor_3", "monitor_4", "monitor_5", "monitor_6", "monitor_7", "monitor_8", "monitor_9", "monitor_10", "monitor_11", "monitor_12", "monitor_13", "monitor_14", "monitor_15", "monitor_16", "monitor_17", "monitor_18", "monitor_19", "monitor_20", "monitor_21", "monitor_22", "monitor_23", "monitor_24", "monitor_25", "monitor_26", "monitor_27", "monitor_28", "monitor_29", "monitor_30", "monitor_31", "monitor_32", "monitor_33", "monitor_34", "monitor_35", "monitor_36", "monitor_37", "monitor_38", "monitor_39", "monitor_40", "monitor_41", "monitor_42", "monitor_43", "monitor_44", "monitor_45", "monitor_46", "monitor_47", "monitor_48", "monitor_49", "monitor_50", "monitor_51", "monitor_52", "monitor_53", "monitor_54", "monitor_55", "monitor_56", "monitor_57", "monitor_58", "monitor_59", "monitor_60", "monitor_61", "monitor_62", "monitor_63", "monitor_64", "monitor_65", "monitor_66", "monitor_67", "monitor_68", "monitor_69", "monitor_70", "monitor_71", "monitor_72", "monitor_73", "monitor_74", "monitor_75", "monitor_76", "monitor_77", "monitor_78", "monitor_79", "monitor_80", "monitor_81", "monitor_82", "monitor_83", "monitor_84", "monitor_85", "monitor_86", "monitor_87", "monitor_88", "monitor_89", "monitor_90", "monitor_91", "monitor_92", "monitor_93", "monitor_94", "monitor_95", "monitor_96", "monitor_97", "monitor_98", "monitor_99", "monitor_100" }
    local monitors = {}
    for _, side in pairs(sides) do
        if peripheral.getType(side) == "monitor" then
            table.insert(monitors, side)
        end
    end

    if #monitors == 0 then
        informUser("No monitors detected.", colors.red)
        return nil
    end

    clearSetupScreen()
    updateLoadingBar(0)
    print("Detected monitors:")
    local columns = math.ceil(#monitors / (term.getSize() / 2))
    for i, monitorSide in ipairs(monitors) do
        if i == term.getSize() / 2 + 1 then
            print("\n") -- Move to next column if the terminal is filled
        end
        print("[" .. i .. "] " .. monitorSide)
    end

    local selection = tonumber(promptUser("Select a monitor by entering its number:", colors.yellow))
    if selection and monitors[selection] then
        return monitors[selection]
    else
        informUser("Invalid selection.", colors.red)
        return nil
    end
end

-- Function to detect and choose a wireless modem
local function chooseModem()
    local sides = { "left", "right", "top", "bottom", "back", "front" }
    local modems = {}
    for _, side in pairs(sides) do
        if peripheral.getType(side) == "modem" and peripheral.call(side, "isWireless") then
            table.insert(modems, side)
        end
    end

    if #modems == 0 then
        informUser("No wireless modems detected.", colors.red)
        return nil
    end

    clearSetupScreen()
    updateLoadingBar(1)  -- Adjusted to reflect the current step
    print("Detected wireless modems:")
    for i, modemSide in ipairs(modems) do
        print("[" .. i .. "] " .. modemSide)
    end

    local selection = tonumber(promptUser("Select a modem by entering its number:", colors.yellow))
    if selection and modems[selection] then
        return modems[selection]
    else
        informUser("Invalid selection.", colors.red)
        return nil
    end
end

-- Skip setup modification
local function skipSetup()
    local skip = promptUser("Skip Setup and use defaults? (y/n)", colors.yellow)
    if skip:lower() == "y" then
        -- Setup defaults
        MODEM = peripheral.wrap(MODEMSIDE)
        return true
    end
    return false
end

-- Channel modification utility functions
local function displayChannels()
    print("Current channels:")
    for i, channel in ipairs(CHANNELS) do
        print("[ " .. i .. " ]" .. " Channel " .. channel)
    end
end

local function printToMonitor(text)
    local x, y = MONITOR.getCursorPos()
    local width, height = MONITOR.getSize()

    if y > height then
        MONITOR.scroll(1)
        MONITOR.setCursorPos(1, height)
    else
        MONITOR.setCursorPos(1, y)
    end

    MONITOR.write(text)
    MONITOR.setCursorPos(1, y + 1)
end

--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
-- Setup
-- Setup MONITOR
clearSetupScreen()
updateLoadingBar(0)  -- No tasks completed yet

--TODO: Make the computers able to work without a monitor

MONITORSIDE = chooseMonitor()
MONITOR = peripheral.wrap(MONITORSIDE)
if not MONITORSIDE then
    informUser("No monitor selected. Canceling operation", colors.red)
    return -- Exit if no monitor was chosen
end
informUser("MONITOR selected. " .. MONITORSIDE .. ".", colors.green)

clearSetupScreen()
updateLoadingBar(1)

------------------------------------------------
if not skipSetup() then
    -- If not skipping, proceed with setup

    -- Setup modem
    MODEMSIDE = chooseModem()
    if not MODEMSIDE then
        informUser("Setup cannot proceed without a wireless modem. Canceling operation", colors.red)
        return -- Exit if no modem was chosen
    end
    MODEM = peripheral.wrap(MODEMSIDE)
    if not MODEM then
        informUser("No modem attached on " .. MODEMSIDE .. ".", colors.red)
        return
    end
    informUser("Wireless modem selected: " .. MODEMSIDE, colors.green)

    local function changeChannel()
        clearSetupScreen()
        updateLoadingBar(2)
        displayChannels()
        local selection = tonumber(promptUser("Enter the number of the channel to change:", colors.yellow))
        if selection and CHANNELS[selection] then
            local newChannel = tonumber(promptUser("Enter new channel number:", colors.yellow))
            if newChannel then
                MODEM.close(CHANNELS[selection])
                CHANNELS[selection] = newChannel
                MODEM.open(newChannel)
                informUser("Channel changed successfully.", colors.green)
            else
                informUser("Invalid channel number.", colors.red)
            end
        else
            informUser("Invalid selection.", colors.red)
        end
    end

    local function deleteChannel()
        clearSetupScreen()
        updateLoadingBar(2)
        displayChannels()
        local selection = tonumber(promptUser("Enter the number of the channel to delete:", colors.red))
        if selection and CHANNELS[selection] then
            MODEM.close(CHANNELS[selection])
            table.remove(CHANNELS, selection)
            informUser("Channel:" .. selection, colors.red)
            informUser("deleted successfully.", colors.green)
        else
            print("Invalid selection.")
        end
    end

    local function addChannel()
        clearSetupScreen()
        updateLoadingBar(2)
        displayChannels()
        local newChannel = tonumber(promptUser("Enter new channel number:", colors.green))
        if newChannel then
            table.insert(CHANNELS, newChannel)
            MODEM.open(newChannel)
            informUser("Channel added successfully.", colors.green)
        else
            informUser("Invalid channel number.", colors.red)
        end
    end

    -- Main interaction loop
    clearSetupScreen()
    updateLoadingBar(2)
    displayChannels()
    local changeChannels = promptUser("Do you want to change the channels? (y/n)", colors.yellow)
    if changeChannels:lower() == "y" then
        while true do
            clearSetupScreen()
            updateLoadingBar(2)
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
                clearSetupScreen()
                updateLoadingBar(2)
                print("Exiting channel modification...")
                break
            else
                informUser("Invalid choice. Please enter a number between 1 and 4.", colors.red)
            end
        end
    end
else
    clearSetupScreen()
    updateLoadingBar(TASKS) -- All tasks completed
    informUser("Using default values for setup.", colors.green)
end

-- Open channels
local function openChannels()
    for _, channel in ipairs(CHANNELS) do
        MODEM.open(channel)
    end
end

clearSetupScreen()
updateLoadingBar(TASKS) -- All tasks completed
openChannels()
informUser("Channels opened successfully.", colors.green)
displayChannels()

informUser("Setup complete. \nMonitor selected:          => " .. MONITORSIDE ..  "\nModem selected             => " .. MODEMSIDE ..  "\nChannels are now configured. \n\nStarting in 5 Seconds...", colors.green)
--------------------------------------------------------------------------------------------------------------

sleep(5)  -- Give the user time to read the message
clearScreen()
print("PowerChargeManager running...")
MODEM.transmit(101, 101, "PowderChargeManager online")  -- Send online status
printToMonitor("PowerChargeManager online. Listening on channel 2.")


-- Main loop
while true do
    local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if senderChannel == 2 then
        printToMonitor("Received message on channel 2: " .. tostring(message))
        local redstoneOutput = 0
        if message == 3 then
            redstoneOutput = 2
        elseif message == 2 then
            redstoneOutput = 5
        elseif message == 1 then
            redstoneOutput = 14
        end

        if redstoneOutput > 0 then
            redstone.setAnalogOutput("left", redstoneOutput)
            MODEM.transmit(101, 101, "RS Power " .. redstoneOutput)
            printToMonitor("Redstone output set to " .. redstoneOutput)
        else
            redstone.setAnalogOutput("left", 0)
            printToMonitor("No redstone output.")
        end
        -- Inside Computer A's main loop, after setting the redstone output
        MODEM.transmit(2, 2, "Mode Received: " .. message)
        printToMonitor("Confirmation sent to Computer C.")

        -- Wait for power down command
        printToMonitor("Waiting for power down command...")
        repeat
            local event, side, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        until senderChannel == 2 and message == true

        redstone.setAnalogOutput("left", 0)
        printToMonitor("Power down command received. Redstone output turned off.")
    end
    sleep(0.2)
end
