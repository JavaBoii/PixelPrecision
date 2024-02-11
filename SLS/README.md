<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="https://media.discordapp.net/attachments/1196171831443468309/1204156230126543003/minecraft_title.png" alt="Create PixelPrecision Project Logo" height="250">
  </a>

<h3 align="center">Project PixelPrecision</h3>

  <p align="center">
    A 2-Part Minecraft Project to create automated cannon/artillery and shell production and loading.<br>
    Including the Programming of an Artillery Computer to hit targets via GPS.
    <br>
    <a href="https://github.com/JavaBoii/PixelPrecision/issues">Report Bug</a>
    ·
    <a href="https://github.com/JavaBoii/PixelPrecision/issues">Request Feature</a>
  </p>
</div>

---

<div align="center">
    <a href="https://github.com/JavaBoii/PixelPrecision/tree/master/SLS"><img src="https://via.placeholder.com/200x200" alt="Project PixelPrecision Logo" height="200"></a>
    <a href="https://github.com/JavaBoii/PixelPrecision/tree/master/CAAS"><img src="https://via.placeholder.com/200x200" alt="Project PixelPrecision Logo" height="200"></a>
</div>

---

<div align="center">
    <img src="https://via.placeholder.com/1000x100" alt="CTA">
    <br>
    <a href=""><img src="https://via.placeholder.com/200x200" alt="Jump to SLS Setup" ></a>
    <a href=""><img src="https://via.placeholder.com/200x200" alt="Jump to SLS documentation" ></a>
    <img src="https://via.placeholder.com/90x200" alt="divider" >
    <img src="https://via.placeholder.com/90x200" alt="divider" >
    <a href=""><img src="https://via.placeholder.com/200x200" alt="Jump to Setup" ></a>
    <a href=""><img src="https://via.placeholder.com/200x200" alt="Jump to Setup" ></a>
</div>

# About
This Part of the Project is the Automated Shell Loading System (SLS) for the Artillery System. <br>
It is designed to automatically prepare shells with various powder charges as requested by either the user or the cannon. <br>
The system is designed to be modular and expandable, allowing for easy integration into any existing artillery system.

---
# Setup
<details>
    <summary><img src="https://icones.pro/wp-content/uploads/2021/06/icone-d-image-orange.png" height="20" alt="image icon"> Computer Setup Overview</summary>

1. **Monitoring Station (`MonitoringStation.lua`)**
2. **Powder Charge Manager (`PowderChargeManager.lua`)**
3. **Safeguard (`Safeguard.lua`)**
4. **Item Manager (`ItemManager.lua`)**
5. **Order Management System (`OrderManagementSystem.lua`)**
6. **Sender is the computer/tablet that orders (`sender.lua`)**
<br><br><br>

    <img src="https://media.discordapp.net/attachments/1196171831443468309/1204278791673872405/Link-Structure.png" alt="Computer Setup Overview" height="350">
</details>

To set up the SLS, you will need to follow the following steps:
1. **Computer/Monitor Setup**: Place down 5 computers. **Beware to leave a spaces open as shown in the picture above**. Place down 5 Monitors either directly in contact with the computer or connected via cables.
    - It is recommended to connect all monitors via 1 cable and use that cable to connect to the computer. Thus the computers can show you available monitors in the network.<br><br>
2. **Download Helper**: On each computer, download `RoleAssignmentScript.lua` by using the following command. <br>
    ```shell
    wget https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/SLS/src/setup/RoleAssignmentScript.lua
    ```
3. **Assign Roles**: Run the `RoleAssignmentScript.lua` on each computer to assign the roles to the computers. <br>
    ```shell
    RoleAssignmentScript.lua
    ```
4. **Initialization Order**: Load the scripts in the following order to ensure proper system initialization:
    - Monitoring Station
    - Powder Charge Manager
    - Safeguard
    - Item Manager
    - Order Management System

By following these steps, your Automated Powder Charge System should now be prepared for use. <br>
Now you can start the programs and follow the directions shown on screen.

---
## Running on the provided schematic

### Required Mods Minecraft 1.20.1

To run the system on a predefined schematic, ensure you have the following mods installed in your Minecraft instance:

- Create
- Create: Big Cannons
- Create: Connected
- Create: Design n' Decor
- Create: Misc & Things
- CC: Tweaked
- Tiny Gates
