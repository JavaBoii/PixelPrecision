print("Select the computer's role by entering the corresponding number:")
print("1. Monitoring Station")
print("2. Powder Charge Manager")
print("3. Safeguard")
print("4. Item Manager")
print("5. Order Management System")
print("6. Sender (Orders computer/tablet)")

local role = read()

if role == "1" then
    shell.run("wget https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/machineOperation/MonitoringStation.lua")
elseif role == "2" then
    shell.run("wget https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/machineOperation/PowderChargeManager.lua")
elseif role == "3" then
    shell.run("wget https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/machineOperation/Safeguard.lua")
elseif role == "4" then
    shell.run("wget https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/machineOperation/ItemManager.lua")
elseif role == "5" then
    shell.run("wget https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/machineOperation/OrderManagementSystem.lua")
elseif role == "6" then
    shell.run("wget https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/orderTransmission/Sender.lua")
else
    error(("Unknown role: %s"):format(role), 0)
end
