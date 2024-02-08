-- Define color utility function
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

-- Get the terminal size
local width, height = term.getSize()

-- Dynamically create a line that spans the width of the terminal when called
local line = string.rep("-", width)

-- Introduction
clearScreen()
setColor(colors.yellow)
print("Select the computer's role by entering the corresponding number:")
setColor(colors.white)
print("1. Monitoring Station")
print("2. Powder Charge Manager")
print("3. Safeguard")
print("4. Item Manager")
print("5. Order Management System")
print("6. Sender (Orders computer/tablet)")
setColor(colors.yellow)
write("Input: ")

local roleMapping = {
    "MonitoringStation.lua",
    "PowderChargeManager.lua",
    "Safeguard.lua",
    "ItemManager.lua",
    "OrderManagementSystem.lua",
    "Sender.lua"
}

local baseUrls = {
    "https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/machineOperation/",
    "https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/orderTransmission/"
}

-- Role selection
local role = read()
local scriptPath = nil

if tonumber(role) >= 1 and tonumber(role) <= 5 then
    scriptPath = baseUrls[1] .. roleMapping[tonumber(role)]
elseif tonumber(role) == 6 then
    scriptPath = baseUrls[2] .. roleMapping[tonumber(role)]
else
    setColor(colors.red)
    print("Unknown role: " .. role)
    return
end

-- Check and delete file if exists and user confirms
local function deleteFileIfConfirmed(fileName)
    if fs.exists(fileName) then
        setColor(colors.orange)
        print("A file named '" .. fileName .. "' already exists. Overwrite it? (yes/no)")
        local confirm = read()
        if confirm:lower() ~= "yes" then
            setColor(colors.yellow)
            print("Operation cancelled. Good day!")
            return false
        else
            fs.delete(fileName)
            if fs.exists(fileName) then  -- Double check if file was actually deleted
                setColor(colors.red)
                print("Failed to delete the file. Check permissions or file status.")
                return false
            end
        end
    end
    return true
end

local fileName = scriptPath:match("([^/]+)$")  -- Extract file name from URL
if not deleteFileIfConfirmed(fileName) then
    return -- Exit if user cancels or deletion fails
end

clearScreen()

setColor(colors.yellow)
print(line)
print(" ")
print("Begin download of: " .. scriptPath .. " in 2 seconds.")
print(" ")
print(line)

sleep(2)  -- Sleep for a second to let the user read the message
clearScreen()

-- Download the file
setColor(colors.blue)
print(line)
print(" ")
shell.run("wget " .. scriptPath)
print(" ")
print(line)
setColor(colors.white)

sleep(2)  -- Sleep for a second to let the user read the message
clearScreen()

-- Check if download was successful
if not fs.exists(fileName) then
    setColor(colors.red)
    print("Download failed or file was not created.")
    return
end

-- Ask to run the downloaded program
setColor(colors.green)
print("Download successful. Would you like to start the program now? (yes/no)")
setColor(colors.yellow)
write("Input: ")
local answer = read()
setColor(colors.white)

if answer:lower() == "yes" then
    clearScreen()
    shell.run(fileName)
else
    setColor(colors.yellow)
    print("Download finished. Good day!")
end

-- Reset color
setColor(colors.white)