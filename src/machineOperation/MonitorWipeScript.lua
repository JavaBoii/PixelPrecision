-- Function to clear a monitor
local function clearMonitor(monitor)
    monitor.clear()
    monitor.setCursorPos(1, 1)
end

-- Iterate through all connected peripherals
for _, side in ipairs(peripheral.getNames()) do
    if peripheral.getType(side) == "monitor" then
        -- Clear the monitor
        local monitor = peripheral.wrap(side)
        clearMonitor(monitor)
    end
end

-- Shut down the computer
os.shutdown()
