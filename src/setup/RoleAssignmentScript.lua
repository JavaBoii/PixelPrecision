local requiredGraphics = {
    "startMenu.nfp",
    "downloadManagerBg.nfp",
    "warning.nfp",
    -- Add more filenames as needed
}

function checkRequiredGraphics()
    local missingFiles = {}
    if not fs.exists("graphics") then
        fs.makeDir("graphics")
        missingFiles = requiredGraphics
    else
        for _, file in ipairs(requiredGraphics) do
            if not fs.exists("graphics/" .. file) then
                table.insert(missingFiles, file)
            end
        end
    end
    return missingFiles
end

function downloadMissingGraphics(missingFiles)
    local allDownloadsSuccessful = true
    for _, file in ipairs(missingFiles) do
        local url = "https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/setup/graphics/" .. file
        local filePath = "graphics/" .. file
        shell.run("wget", url, filePath)

        -- After attempting to download, check if the file now exists
        if not fs.exists(filePath) then
            -- If the file doesn't exist, the download failed
            term.setTextColor(colors.red)
            print("Failed to download: " .. file)
            allDownloadsSuccessful = false
            break -- Exit the loop early since a download failed
        end
    end

    if not allDownloadsSuccessful then
        print("There has been a problem downloading the needed resources.")
        print("Please check your internet connection and try again.")
        return false
    else
        return true
    end
end



function promptDownloadResources(missingFiles)
    term.clear()
    term.setCursorPos(1, 1)
    term.setTextColor(colors.yellow)
    print("Resources missing. Download now? (y/n)")
    write("Input: ")
    term.setTextColor(colors.white)
    local answer = read()
    if answer:lower() == "y" then
        local success = downloadMissingGraphics(missingFiles)
        if not success then
            -- Stop further execution since there was a problem downloading resources
            return false
        end
    else
        -- If the user chooses not to download the missing resources, also halt the program
        term.setTextColor(colors.red)
        print("Cannot proceed without required resources.")
        return false
    end
    return true
end

-- functions

local window = {
    "start",
    "SLS_download_manager",
    "CAAS_download_manager",
}

local baseUrls = {
    "https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/machineOperation/",
    "https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/orderTransmission/",
    "https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/dddd/"
}

local roleMappings = {
    {
        {name = "MonitoringStation.lua", url = baseUrls[1] .. "MonitoringStation.lua"},
        {name = "PowderChargeManager.lua", url = baseUrls[1] .. "PowderChargeManager.lua"},
        {name = "Safeguard.lua", url = baseUrls[1] .. "Safeguard.lua"},
        {name = "ItemManager.lua", url = baseUrls[1] .. "ItemManager.lua"},
        {name = "OrderManagementSystem.lua", url = baseUrls[1] .. "OrderManagementSystem.lua"},
        -- For Sender.lua, specify its unique URL
        {name = "Sender.lua", url = baseUrls[2] .. "Sender.lua"},
    },
    {
        {name = "AimingSystem.lua", url = baseUrls[3] .. "AimingSystem.lua"},
        {name = "lol.lua", url = baseUrls[3] .. "lol.lua"},
        {name = "AzimuthControl.lua", url = baseUrls[3] .. "AzimuthControl.lua"},
        -- Add more programs with unique URLs as needed
    }
}


local currentWindow = window[1]

function drawDesk(image)
    deskimage = paintutils.loadImage(image)
    paintutils.drawImage(deskimage, 1, 1)
end

function drawMessageBox()
    drawDesk("graphics/warning.nfp")

    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.yellow)

    term.setCursorPos(23, 7)
    term.write("WARNING!")

    term.setCursorPos(18, 9)
    term.write("Please choose what")
    term.setCursorPos(18, 10)
    term.write("you want to do")
    term.setCursorPos(18, 11)
    term.write("with this file.")

    term.setBackgroundColor(colors.red)
    term.setCursorPos(37, 6)
    term.write("X")

    term.setTextColor(colors.white)

    term.setBackgroundColor(colors.blue)
    term.setCursorPos(16, 15)
    term.write("Reinstall")

    term.setBackgroundColor(colors.red)
    term.setCursorPos(32, 15)
    term.write("Delete")
end

function drawMenu()
    drawDesk("graphics/startMenu.nfp")
    term.setCursorPos(1, 1)
    print("[menu]")
    term.setCursorPos(11, 3)
    print("select project to download from:")
    term.setCursorPos(1, 2)
    currentWindow = window[1]
end

function drawSLS()
    drawDesk("graphics/downloadManagerBg.nfp")
    term.setCursorPos(1, 1)
    term.setBackgroundColor(colors.gray)
    write("[menu]")
    term.setCursorPos(18, 1)
    write("Selected part: SLS")
    term.setBackgroundColor(colors.black)
    term.setCursorPos(10, 3)
    write("select program you want to install")
    term.setCursorPos(3, 5)
    write("1. Monitoring Station")
    term.setCursorPos(3, 7)
    write("2. Powder Charge Manager")
    term.setCursorPos(3, 9)
    write("3. Safeguard")
    term.setCursorPos(3, 11)
    write("4. Item Manager")
    term.setCursorPos(3, 13)
    write("5. Order Management System")
    term.setCursorPos(3, 15)
    write("6. Sender (Orders computer/tablet)")
    status(1) -- Assuming SLS role mapping
    -- Use status(2) for CAAS role mapping elsewhere as needed
    currentWindow = window[2]
end

function drawCAAS()
    drawDesk("graphics/downloadManagerBg.nfp")
    term.setCursorPos(1, 1)
    term.setBackgroundColor(colors.gray)
    write("[menu]")
    term.setCursorPos(18, 1)
    write("Selected part: CAAS")
    term.setBackgroundColor(colors.black)
    term.setCursorPos(10, 3)
    write("select program you want to install")
    term.setCursorPos(3, 5)
    write("1. Placeholder")
    term.setCursorPos(3, 7)
    write("2. Placeholder")
    term.setCursorPos(3, 9)
    write("3. Placeholder")
    status(2) -- 1 = SLS, 2 = CAAS
    currentWindow = window[3]
end

function checkInstalled(programInfo)
    local programName = programInfo.name
    return fs.exists(programName)
end

function status(mappingIndex)
    local roleMapping = roleMappings[mappingIndex]

    for i, program in ipairs(roleMapping) do
        local installed = checkInstalled(program)
        term.setCursorPos(40, 3 + i * 2)
        if installed then
            term.setBackgroundColor(colors.green)
            term.write(" installed ")

            -- Draw "run" button in red to the left of "installed" status
            term.setBackgroundColor(colors.red)
            term.setCursorPos(34, 3 + i * 2) -- Adjust position as necessary
            term.write(" run ")
            term.setBackgroundColor(colors.black) -- Reset background color
            term.write(" ")
        else
            term.setBackgroundColor(colors.blue)
            term.write(" download  ")
        end
        term.setBackgroundColor(colors.black) -- Reset background color
    end
end


function attemptDownloadAndDisplayStatus(mappingIndex, programIndex, y)
    local programInfo = roleMappings[mappingIndex][programIndex]
    local fileName = programInfo.name

    if fs.exists(fileName) then
        -- If the file is already installed, prompt the user for action
        drawMessageBox()

        while true do
            local event, button, x, y = os.pullEvent("mouse_click")
            if x >= 16 and x <= 24 and y == 15 then -- Reinstall button
                fs.delete(fileName) -- Delete the existing file
                term.setTextColor(colors.black)
                term.setBackgroundColor(colors.black)
                shell.run("wget " .. programInfo.url .. " " .. fileName) -- Download again
                term.setTextColor(colors.white)
                break
            elseif x >= 32 and x <= 37 and y == 15 then -- Delete button
                fs.delete(fileName) -- Delete the file
                break
            elseif x == 37 and y == 6 then -- Close button
                break
            end
        end

        -- After action, redraw the previous GUI
        if currentWindow == window[2] then
            drawSLS()
        elseif currentWindow == window[3] then
            drawCAAS()
        end

        -- Update the status after action
        status(mappingIndex)
    else
        term.setTextColor(colors.black)
        term.setBackgroundColor(colors.black)
        -- Download logic (simplified for illustration)
        shell.run("wget " .. programInfo.url .. " " .. fileName)
        term.setTextColor(colors.white)
        -- Redraw the window to update the status
        if currentWindow == window[2] then
            drawSLS()
        elseif currentWindow == window[3] then
            drawCAAS()
        end

        -- Update button to display download status
        term.setCursorPos(40, y)
        if fs.exists(fileName) then
            term.setBackgroundColor(colors.green)
            term.write(" success   ")
        else
            term.setBackgroundColor(colors.red)
            term.write(" failure   ")
        end
        term.setBackgroundColor(colors.black) -- Reset background color for next text
    end

end


function menu()
    while true do
        local event, button, x, y = os.pullEvent("mouse_click")
        local mappingIndex

        if currentWindow == window[2] then
            mappingIndex = 1  -- SLS download manager
        elseif currentWindow == window[3] then
            mappingIndex = 2  -- CAAS download manager
        else
            mappingIndex = nil  -- Not in a download manager window
        end

        if button == 1 and x >= 1 and x <= 6 and y == 1 then
            drawMenu()
        end

        if currentWindow == window[1] and button == 1 and x >= 12 and x <= 24 and y >= 5 and y <= 13 then
            drawSLS()
        end

        if currentWindow == window[1] and button == 1 and x >= 29 and x <= 41 and y >= 5 and y <= 13 then
            drawCAAS()
        end

        if mappingIndex and button == 1 then
            for programIndex = 1, #roleMappings[mappingIndex] do
                local buttonY = 5 + (programIndex - 1) * 2
                if y == buttonY and x >= 34 and x <= 38 then -- Adjust these coordinates as necessary
                    local programName = roleMappings[mappingIndex][programIndex].name
                    if fs.exists(programName) then
                        shell.run(programName)
                    end
                    break
                elseif y == buttonY and x >= 40 and x <= 50 then
                    attemptDownloadAndDisplayStatus(mappingIndex, programIndex, y)
                    break
                end
            end
        end
    end
end

--running functions

function main()
    local missingGraphics = checkRequiredGraphics()
    if #missingGraphics > 0 then
        local canProceed = promptDownloadResources(missingGraphics)
        if not canProceed then
            print("Exiting due to missing resources.")
            return
        end
    end

    -- If all resources are present or successfully downloaded, proceed with the main UI
    drawDesk("graphics/startMenu.nfp")
    drawMenu()
    menu()
end

main()


