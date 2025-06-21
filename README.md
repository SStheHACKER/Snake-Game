# 🐍 Snake Game on FPGA

This project implements the classic **Snake Game** entirely in hardware using an **FPGA**. Designed using **Verilog**, it showcases a hardware-level approach to game development by interfacing with a VGA display and including a custom-built **random number generator** for dynamic fruit placement.

---

## 🚀 Overview

The Snake Game is a classic arcade game in which the player controls a snake that grows longer as it consumes randomly placed fruits. The game ends when the snake collides with itself or the game boundary.

In this hardware version:
- All game logic is implemented using **Verilog HDL**.
- A **custom random number generator** is used for fruit placement.
- **VGA output** allows the game to be displayed on a monitor in real time.
- The game is fully synthesized and deployed on an **FPGA development board**, such as the Xilinx Basys-3 or equivalent.

---
![image](https://github.com/user-attachments/assets/4af22d70-c7c0-419a-9734-cc1093ad8eee)\

![image](https://github.com/user-attachments/assets/378c2e24-a1ec-4520-b746-af95b338d7f6)



## 🧩 Features

### 🎮 Classic Snake Gameplay
- Control a growing snake on a 2D grid.
- Collect randomly generated fruits.
- Avoid collisions with walls or the snake’s own body.

### 🧠 Verilog-Based Game Logic
- All control and display logic written in **pure Verilog**, demonstrating digital design and finite state machine (FSM) principles.
- Handles snake movement, collision detection, and fruit consumption.

### 🎲 Random Number Generator (RNG)
- Implements a **Linear Feedback Shift Register (LFSR)**-based RNG in Verilog for fruit spawning.
- Ensures fruits are placed at random grid positions without overlapping the snake.

### 🖥️ VGA Display Interface
- Outputs the game frame via **VGA at 640x480 resolution**.
- Grid, snake, and fruit are rendered in different colors.
- Pixel mapping and synchronization handled in hardware.
- It uses only 5000 LUTs with 48 BRAMs(BRAms used for Start and End Screens).

---

## 🔧 Hardware Requirements

- FPGA Development Board (e.g., Digilent Basys-3 or Nexys A7)
- VGA-compatible Monitor and Cable
- Clock frequency: 100 MHz (can be scaled using clock dividers)
- Push Buttons for directional control (Up, Down, Left, Right)
- 7-Segment Display or LEDs for optional score display

---
