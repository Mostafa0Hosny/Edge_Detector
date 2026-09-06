# Verilog FSM Edge Detector Suite

A complete Verilog HDL design suite implementing Finite State Machine (FSM) based edge detectors. An edge detector monitors an incoming signal (`IN`) and generates a single-clock-cycle strobe pulse (`Tic`) whenever a valid signal transition occurs.

This repository covers all six standard variations across two fundamental state machine architectures—**Moore** and **Mealy**—for **Rising Edge**, **Falling Edge**, and **Dual-Edge (Rising & Falling)** detection.

---

## Architecture & Trade-Off Analysis

| Feature | Moore FSM Architecture | Mealy FSM Architecture |
| :--- | :--- | :--- |
| **Output Dependency** | Purely depends on current state | Depends on current state AND input `IN` |
| **Output Latency** | 1 clock cycle delay | 0 clock cycles (Immediate assertion) |
| **Glitch Immunity** | High (Output is synchronous with `CLK`) | Sensitive to asynchronous input glitches |
| **State Complexity** | Requires **3 states** (`s0`, `s1`, `s2`) | Requires **2 states** (`s0`, `s1`) |

---

## Detailed Module Inventory

### 1. Rising Edge Detectors (0 → 1 Transition)

* **`Edge_Detector_Moore_Rising.v`**
  * **Type**: Moore FSM
  * **Behavior**: Detects a low-to-high transition on `IN`. The output pulse `Tic_Moore` is asserted for 1 clock cycle starting on the clock edge immediately *after* the transition.
  * **States**: `s0` (Zero / Idle), `s1` (Edge Detected / Pulse Active), `s2` (One / Hold).

* **`Edge_Detector_Mealy_Rising.v`**
  * **Type**: Mealy FSM
  * **Behavior**: Detects a low-to-high transition on `IN`. The output pulse `Tic_Mealy` asserts asynchronously the moment `IN` goes high while in state `s0`, and clears on the next clock edge.
  * **States**: `s0` (Zero / Idle), `s1` (One / Hold).

---

### 2. Falling Edge Detectors (1 → 0 Transition)

* **`Edge_Detector_Moore_Falling.v`**
  * **Type**: Moore FSM
  * **Behavior**: Detects a high-to-low transition on `IN`. The output pulse `Tic_Moore` is asserted for 1 clock cycle on the clock edge after `IN` drops to 0.
  * **States**: `s0` (One / Idle), `s1` (Edge Detected / Pulse Active), `s2` (Zero / Hold).

* **`Edge_Detector_Mealy_Falling.v`**
  * **Type**: Mealy FSM
  * **Behavior**: Detects a high-to-low transition on `IN`. Output `Tic_Mealy` asserts immediately when `IN == 0` while in state `s0`.
  * **States**: `s0` (One / Idle), `s1` (Zero / Hold).

---

### 3. Dual-Edge Detectors (0 → 1 AND 1 → 0 Transitions)

* **`Edge_Detector_Moore_Rising_Falling.v`**
  * **Type**: Moore FSM
  * **Behavior**: Generates a 1-cycle `Tic_Moore` pulse whenever `IN` changes state in either direction.
  * **States**: 
    * `s0`: Steady LOW state (or initial state).
    * `s1`: Pulse assertion state (asserts `Tic_Moore = 1`).
    * `s2`: Steady HIGH state.

* **`Edge_Detector_Mealy_Rising_Falling.v`**
  * **Type**: Mealy FSM
  * **Behavior**: Generates an immediate `Tic_Mealy` pulse whenever `IN` toggles between 0 and 1.
  * **States**: 
    * `s0`: Tracks LOW input state.
    * `s1`: Tracks HIGH input state.

---

## State Transition Tables

### Moore Both-Edges (`Edge_Detector_Moore_Rising_Falling.v`)

| Current State | Input (`IN`) | Next State | Output (`Tic_Moore`) | Description |
| :---: | :---: | :---: | :---: | :--- |
| `s0` | 0 | `s0` | `0` | Idle in LOW state |
| `s0` | 1 | `s1` | `0` | Transition detected → Move to pulse state |
| `s1` | 1 | `s2` | `1` | Assert pulse → Move to steady HIGH state |
| `s1` | 0 | `s0` | `1` | Assert pulse → Input dropped back LOW |
| `s2` | 1 | `s2` | `0` | Steady HIGH state |
| `s2` | 0 | `s1` | `0` | Transition detected → Move to pulse state |

### Mealy Both-Edges (`Edge_Detector_Mealy_Rising_Falling.v`)

| Current State | Input (`IN`) | Next State | Output (`Tic_Mealy`) | Description |
| :---: | :---: | :---: | :---: | :--- |
| `s0` | 0 | `s0` | `0` | Idle in LOW state |
| `s0` | 1 | `s1` | `1` | Rising edge detected → Immediate pulse |
| `s1` | 1 | `s1` | `0` | Steady HIGH state |
| `s1` | 0 | `s0` | `1` | Falling edge detected → Immediate pulse |

---

## Repository Directory Structure

```text
.
├── rtl/
│   ├── Edge_Detector_Moore_Rising.v
│   ├── Edge_Detector_Moore_Falling.v
│   ├── Edge_Detector_Moore_Rising_Falling.v
│   ├── Edge_Detector_Mealy_Rising.v
│   ├── Edge_Detector_Mealy_Falling.v
│   └── Edge_Detector_Mealy_Rising_Falling.v
├── tb/
│   ├── Edge_Detector_Moore_Rising_TB.v
│   ├── Edge_Detector_Moore_Falling_TB.v
│   ├── Edge_Detector_Moore_Rising_Falling_TB.v
│   ├── Edge_Detector_Mealy_Rising_TB.v
│   ├── Edge_Detector_Mealy_Falling_TB.v
│   └── Edge_Detector_Mealy_Rising_Falling_TB.v
├── docs/
│   ├── edge_detector_moore_rising.png
│   ├── edge_detector_moore_Falling.png
│   ├── Edge_Detector_Moore_Rising_Falling.png
│   ├── Edge_Detector_Mealy_Rising.png
│   ├── Edge_Detector_Mealy_Falling.png
│   └── Edge_Detector_Mealy_Rising_Falling.png
└── README.md
