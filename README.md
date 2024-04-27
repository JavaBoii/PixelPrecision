# Contributions are welcome

---

---

---

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Release][release-shield]][release-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
<img src="https://github.com/JavaBoii/PixelPrecision/assets/79570962/d3d94f18-888c-4d25-99d5-2d279359455a" alt="Create PixelPrecision Project Logo" height="250">

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

<details>
    <summary>Table of contents</summary>

- [Introduction](#introduction)
- [Documentation Overview](#documentation-overview)
  - [Part 1: Automated Powder Charge System](#automated-powder-charge-system)
    - [System Architecture](#system-architecture)
    - [Component Details](#component-details)
      - [Monitoring Station]()
      - [Powder Charge Manager]()
      - [Safeguard]()
      - [Item Manager]()
      - [Order Management System]()
      - [Sender]()
    - [Workflow Overview](#workflow-overview)
  - [Part 2: Automated Artillery Loading and Aiming System](#automated-artillery-loading-and-aiming-system) (WIP)
- [Getting Started](#getting-started)
  - [Version 1: Basic Setup](#version-1-basic-setup)
    - [Step 1: Arranging Computers and Monitors](#step-1-arranging-computers-and-monitors)
    - [Step 2: Loading Programs](#step-2-loading-programs)
  - [Version 2: Running on the provided schematic](#version-2-running-on-the-provided-schematic)
    - [Required Mods](#required-mods)
    - [Step 1: Placing the Schematic](#step-1-placing-the-schematic)
    - [Step 2: Preparing Computers](#step-2-preparing-computers)
    - [Step 3: Initialization](#step-3-initialization)
- [Roadmap](#roadmap)
- [License](#license)
- [Acknowledgments](#acknowledgments)

</details>

# PixelPrecision Documentation

<details>
    <summary>Introduction, About section and module functionality</summary>

## Introduction

This project of mine was a way to challenge myself in Minecraft with the Create, Create:Big Cannons and ComputerCraft:Tweaked mod. <br>
So it started with the idea of creating an automated Artillery with the help of ComputerCraft, which quickly turned into a nightmare.<br>
So I sat down to code and build a shell delivery System. The Artillery Computer is a WIP, since I have to calculate

- the gravity and acceleration of the shots
- time that each Create speed takes to make the gun do a 360° to get horizontal °/s
- time that each Create speed takes to make the gun go from 0 to its maximum 60° to get vertical °/s

The project is divided into two distinct but interconnected parts:
the Automated Powder Charge System and the Automated Artillery Loading and Aiming System. <br>
Each part plays a crucial role in the operation,
ensuring that the artillery can dynamically deliver shells of varying powers to the target upon request and in the end destroy it with the Computers Assistance.

## Part 1: Automated Powder Charge System

The Automated Powder Charge System is made to dynamically deliver shells with varying levels of power (1-4) to the artillery gun.
This system automates the entire process of managing powder charges, from receiving orders to the precise dispensing of the charges.
It consists of several key components, including a

- simple commandline interface for order input
- a monitoring station for real-time status updates
- a safeguard system for ensuring dispensing accuracy
- an order management system for process coordination
- an item manager that controls the physical dispensing mechanism.

**Key Features:**

- **Dynamic Dispensing**: Adjusts the amount and type of powder charge based on user input, allowing for customization of shell power.
- **Real-Time Monitoring**: Provides live feedback on the system's status, enhancing overview and user intervention.
- **Accuracy Assurance**: Incorporates counting mechanisms to ensure that the exact amount of powder charge is dispensed, maintaining reliability. ( _known bug: the system misses 0.1% of the outbound shells, causing a freeze in the End_ )
- **Automated Coordination**: Centralizes order processing and coordinates the actions of various components to streamline operations.

## Part 2: Automated Artillery Loading and Aiming System

WIP

---

# Automated Powder Charge System Documentation

## System Architecture

The Automated Powder Charge System is a sophisticated, modular network designed within Minecraft, powered by the ComputerCraft mod. This system demonstrates the integration of automated processes with real-time monitoring and control, utilizing Lua scripting for communication and operation across multiple components.

The architecture comprises six key components, each responsible for distinct aspects of the system's functionality:

1. **Monitoring Station (`MonitoringStation.lua`)**
2. **Powder Charge Manager (`PowderChargeManager.lua`)**
3. **Safeguard (`Safeguard.lua`)**
4. **Item Manager (`ItemManager.lua`)**
5. **Order Management System (`OrderManagementSystem.lua`)**
6. **Sender is the computer/tablet that orders (`sender.lua`)**

<details>
    <summary><img src="https://icones.pro/wp-content/uploads/2021/06/icone-d-image-orange.png" height="20" alt="image icon"> Isometric View of the Plant</summary>
    <img src="https://github.com/JavaBoii/PixelPrecision/assets/79570962/613d2ae6-f366-439d-8711-137682a5b437" alt="Isometric view of Shell production" height="650">
</details>

---

## Component Details

<details>
    <summary><img src="https://icones.pro/wp-content/uploads/2021/06/icone-d-image-orange.png" height="20" alt="image icon"> Isometric X-Ray View for reference</summary>
    <img src="https://github.com/JavaBoii/PixelPrecision/assets/79570962/3af9159b-88ff-4439-a672-a87cc5487370" alt="Isometric X-RAY view of Shell production" height="550">
</details>

Shown in image above:
[1]: [Shell dispenser](#item-manager)
[2]: [Shell Power controlling](#powder-charge-manager)
[3]: [Outbound Shell counting](#safeguard-safeguardlua)

### Monitoring Station (`MonitoringStation.lua`)

The Monitoring Station acts as the central hub for real-time feedback and system status updates.
It displays information on a connected monitor, using color-coded text to differentiate between various messages and statuses.

**Features:**

- Displays real-time updates from all system components.
- Utilizes color coding for clear, at-a-glance information dissemination.

### Powder Charge Manager (`PowderChargeManager.lua`)

This component controls the shell power operation, adjusting settings based on the mode (1-4) specified by incoming orders.
It ensures the dispensing process aligns with the requested parameters.

**Key Features:**

- Receives and processes mode commands.
- Adjusts redstone output for precise control over the dispensing mechanism.
- Provides status updates to the Monitoring Station.

### Safeguard (`Safeguard.lua`)

( ⚠️ _**known bug**: the system misses 0.1% of the outbound shells, causing a freeze in the End_ ⚠️ )<br>
The Safeguard ensures the accuracy of the dispensing process by counting each dispensed item.
It monitors redstone signals and communicates the count to the Monitoring Station, verifying that the quantity dispensed matches the order.

**Features:**

- Monitors and counts dispensed items for accuracy.
- Communicates count and status updates in real-time.

### Item Manager (`ItemManager.lua`)

Directly responsible for the physical dispensing of items, the Item Manager adjusts its operations based on the specifics of received orders,
ensuring the correct quantity and mode of powder charges are dispensed.

**Features:**

- Controls the physical dispensing mechanism.
- Adjusts operations dynamically based on order details.

### Order Management System (`OrderManagementSystem.lua`)

As the coordinator of the dispensing process, the Order Management System processes incoming orders,
communicates with the Item Manager and Safeguard, and maintains the system's operational flow.

**Features:**

- Processes and coordinates the execution of orders.
- Ensures communication and synchronization between system components.

### Sender (`sender.lua`)

The Sender provides the user interface for the system, allowing for the input of order details such as mode and quantity.
It validates inputs and transmits the order to the system for processing.

**Features:**

- Captures and validates user input.
- Initiates the order process by transmitting details to the system.

## Workflow Overview

The Automated Powder Charge System operates through a coordinated workflow:

1. **Order Placement**: The user inputs order details into the Sender, which transmits the validated order to the system.
2. **Order Coordination**: The Order Management System receives the order, initiating the dispensing process with the Item Manager.
3. **Monitoring**: The Monitoring Station displays real-time updates, providing visibility into the system's operations.
4. **Verification**: Safeguard verifying accuracy.
5. **Completion**: Upon order fulfillment, the system signals completion, readying itself for the next order.

</details>

---

<!-- GETTING STARTED -->

# Getting Started with the Automated Powder Charge System

## Version 1: Basic Setup

### Step 1: Arranging Computers and Monitors

1. **Place Computers**: Arrange five computers in a line on your Minecraft world. <br>⚠️ **Ensure there is one block space to the left of the third computer and one block space to the right of the fourth computer, as these spaces are necessary for the system's operation.** ⚠️<br>The second computer will output its redstone signal to the left.

2. **Connect to Wired Network**: Attach wired modems to the bottom of each computer. Connect these modems with network cables to form a single wired network. This network allows the computers to communicate with each other.

3. **Attach Monitors**: Connect monitors to the network. Each computer, except the first one (Monitoring Station), should have its monitor connected to ensure that output can be displayed correctly. The first computer will directly interact with its attached monitor without going through the network.

4. **Attach Wireless Modems**: Place wireless modems on top of each computer, except for the first one. This setup enables wireless communication for sending and receiving data across the system.

<details>
    <summary><img src="https://icones.pro/wp-content/uploads/2021/06/icone-d-image-orange.png" height="20" alt="image icon"> Computer Setup Overview</summary>
    <img src="https://github.com/JavaBoii/PixelPrecision/assets/79570962/65c86488-8aa2-4891-91ed-a647b7551af0" alt="Computer Setup Overview" height="350">
</details>

### Step 2: Loading Programs

1. **Load Lua Scripts**: On each computer, load the respective Lua script that is being displayed on your screen by using the following command. <br>
   ```shell
   wget https://raw.githubusercontent.com/JavaBoii/PixelPrecision/master/src/setup/RoleAssignmentScript.lua
   ```
2. **Initialization Order**: After loading the scripts, start the computers in the following order to ensure proper
   system initialization:
   - Monitoring Station
   - Powder Charge Manager
   - Safeguard
   - Item Manager
   - Order Management System

By following these steps, your Automated Powder Charge System should now be set up and ready for operation.

## Version 2: Running on the provided schematic

### Required Mods Minecraft 1.20.1

To run the system on a predefined schematic, ensure you have the following mods installed in your Minecraft instance:

- Create
- Create: Big Cannons
- Create: Connected
- Create: Design n' Decor
- Create: Misc & Things
- CC: Tweaked
- Tiny Gates

<!-- ROADMAP -->

## Roadmap

- [x] Part 1: Automated Powder Charge System
  - [x] Add documentation
  - [x] Add schematics
  - [ ] Fix counting Issue
- [ ] Part 2: Artillery Computer
  - [ ] Add documentation
  - [ ] Add schematics

See the [open issues](https://github.com/JavaBoii/PixelPrecision/issues) for a full list of proposed features (and known issues).

<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- ACKNOWLEDGMENTS -->

## Acknowledgments/Credits

- [Choose an Open Source License](https://choosealicense.com)
- [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
- [Img Shields](https://shields.io)
- [Plant design by my friend NeoMaestro](https://github.com/placeholder)
- [Code restructure suggestion by u/fatboychummy](https://www.reddit.com/user/fatboychummy/)

<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/JavaBoii/PixelPrecision?style=for-the-badge
[contributors-url]: https://github.com/JavaBoii/PixelPrecision/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/JavaBoii/PixelPrecision?style=for-the-badge
[forks-url]: https://github.com/JavaBoii/PixelPrecision/network/members
[stars-shield]: https://img.shields.io/github/stars/JavaBoii/PixelPrecision?style=for-the-badge
[stars-url]: https://github.com/JavaBoii/PixelPrecision/stargazers
[issues-shield]: https://img.shields.io/github/issues/JavaBoii/PixelPrecision?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[release-shield]: https://img.shields.io/github/v/release/JavaBoii/PixelPrecision?style=for-the-badge
[release-url]: https://github.com/JavaBoii/PixelPrecision/releases
[license-shield]: https://img.shields.io/github/license/JavaBoii/PixelPrecision?style=for-the-badge
[license-url]: https://github.com/JavaBoii/PixelPrecision/blob/master/LICENSE
