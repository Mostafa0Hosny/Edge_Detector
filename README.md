# Edge Detector 
# Verilog FSM Digital Design Library: Switch Debouncer & Edge Detector Suite

A comprehensive Verilog HDL library implementing essential Finite State Machine (FSM) building blocks for FPGA and ASIC designs. This collection includes a parameterized mechanical switch debouncing circuit and a complete suite of 6 FSM edge detectors (Moore and Mealy architectures for rising, falling, and dual-edge detection).

---

## 1. Module Architecture Overview

### A. Switch Debouncing Circuit (`Debouncing_Circuit.v`)
Mechanical switches and pushbuttons suffer from contact bounce, generating high-frequency electrical noise during state changes. The debouncing circuit uses a parameterized modulo-N counter combined with an 8-state finite state machine to filter out glitches and output a clean, stable digital signal.

* **Parameterized Filtering**: Set via parameter `tic` (default: `10`) to control sampling duration.
* **Stable Output**: Output signal `db` only transitions after the raw switch input (`SW`) remains unchanged across 3 consecutive sampling strobe intervals (`m_tic`).

```
               +------------------------------------------------------+
               |                  Debouncing_Circuit                  |
               |                                                      |
 [CLK] ------->| [Modulo-N Counter] ---> m_tic                        |
 [RST] --------+-----> [FSM Control Logic] <--- SW                     |
               |             |                                        |
               |             +--------------------------------------> db
               +------------------------------------------------------+
```

### B. Edge Detector Suite (`Edge_Detector_*.v`)
Edge detectors generate a single-clock-cycle strobe pulse (`Tic`) whenever a specified transition occurs on an input signal (`IN`). This repository implements all variations across two primary FSM architectures:

1. **Moore Architecture**: Output pulse (`Tic_Moore`) depends purely on current state. Provides synchronous, glitch-free outputs with 1 clock cycle of transition latency. Uses 3 states (`s0`, `s1`, `s2`).
2. **Mealy Architecture**: Output pulse (`Tic_Mealy`) depends combinationally on current state and input signal (`IN`). Provides immediate zero-latency pulse assertion upon edge detection. Uses 2 states (`s0`, `s1`).

---

## 2. Inventory of Modules & Files

| Module Name | Module Type | Key Functionality / Detection Type | RTL File | Testbench File | Waveform Image |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `Debouncing_Circuit` | FSM + Counter | Parameterized Mechanical Noise Filter | `rtl/Debouncing_Circuit.v` | `tb/Debouncing_Circuit_TB.v` | `docs/Wave form.png` |
| `Edge_Detector_Moore_Rising` | Moore FSM | Single-cycle pulse on Rising Edge (0 $
ightarrow$ 1) | `rtl/Edge_Detector_Moore_Rising.v` | `tb/Edge_Detector_Moore_Rising_TB.v` | `docs/edge_detector_moore_rising.png` |
| `Edge_Detector_Moore_Falling` | Moore FSM | Single-cycle pulse on Falling Edge (1 $
ightarrow$ 0) | `rtl/Edge_Detector_Moore_Falling.v` | `tb/Edge_Detector_Moore_Falling_TB.v` | `docs/edge_detector_moore_Falling.png` |
| `Edge_Detector_Moore_Rising_Falling` | Moore FSM | Single-cycle pulse on Both Edges | `rtl/Edge_Detector_Moore_Rising_Falling .v` | `tb/Edge_Detector_Moore_Rising_Falling _TB.v` | `docs/Edge_Detector_Moore_Rising_Falling.png` |
| `Edge_Detector_Mealy_Rising` | Mealy FSM | Zero-latency pulse on Rising Edge (0 $
ightarrow$ 1) | `rtl/Edge_Detector_Mealy_Rising.v` | `tb/Edge_Detector_Mealy_Rising_TB.v` | `docs/Edge_Detector_Mealy_Rising.png` |
| `Edge_Detector_Mealy_Falling` | Mealy FSM | Zero-latency pulse on Falling Edge (1 $
ightarrow$ 0) | `rtl/Edge_Detector_Mealy_Falling.v` | `tb/Edge_Detector_Mealy_Falling_TB.v` | `docs/Edge_Detector_Mealy_Falling.png` |
| `Edge_Detector_Mealy_Rising_Falling` | Mealy FSM | Zero-latency pulse on Both Edges | `rtl/Edge_Detector_Mealy_Rising _Falling.v` | `tb/Edge_Detector_Mealy_Rising _Falling _TB.v` | `docs/Edge_Detector_Mealy_Rising _Falling.png` |

---

## 3. Directory Layout

Recommended directory structure for uploading to GitHub:

```text
.
├── rtl/
│   ├── Debouncing_Circuit.v
│   ├── Edge_Detector_Moore_Rising.v
│   ├── Edge_Detector_Moore_Falling.v
│   ├── Edge_Detector_Moore_Rising_Falling .v
│   ├── Edge_Detector_Mealy_Rising.v
│   ├── Edge_Detector_Mealy_Falling.v
│   └── Edge_Detector_Mealy_Rising _Falling.v
├── tb/
│   ├── Debouncing_Circuit_TB.v
│   ├── Edge_Detector_Moore_Rising_TB.v
│   ├── Edge_Detector_Moore_Falling_TB.v
│   ├── Edge_Detector_Moore_Rising_Falling _TB.v
│   ├── Edge_Detector_Mealy_Rising_TB.v
│   ├── Edge_Detector_Mealy_Falling_TB.v
│   └── Edge_Detector_Mealy_Rising _Falling _TB.v
├── docs/
│   ├── Wave form.png
│   ├── edge_detector_moore_rising.png
│   ├── edge_detector_moore_Falling.png
│   ├── Edge_Detector_Moore_Rising_Falling.png
│   ├── Edge_Detector_Mealy_Rising.png
│   ├── Edge_Detector_Mealy_Falling.png
│   └── Edge_Detector_Mealy_Rising _Falling.png
└── README.md
```

---

## 4. Module Interface Specifications

### Debouncing Circuit (`Debouncing_Circuit.v`)
* **Parameters**: `tic` (default: `10`) - Clock cycles per sampling strobe pulse.
* **Inputs**: `CLK` (System Clock), `RST` (Async Active-Low Reset), `SW` (Raw switch input).
* **Outputs**: `db` (Debounced output signal).

### Edge Detectors (`Edge_Detector_*.v`)
* **Inputs**: `CLK` (System Clock), `RST` (Async Active-Low Reset), `IN` (Input signal).
* **Outputs**: `Tic_Moore` / `Tic_Mealy` (Single-clock-cycle pulse generated upon edge detection).

---

## 5. Verification & Simulation Instructions

All modules come with dedicated testbenches that inject noise/pulses and output VCD trace files (`.vcd`) for visual verification.

### Simulation Steps (ModelSim / QuestaSim)

1. **Compile All Modules**:
   ```bash
   vlib work
   vlog rtl/*.v tb/*.v
   ```

2. **Simulate a Specific Testbench** (e.g., Switch Debouncer):
   ```bash
   vsim -c Debouncing_Circuit_TB -do "run -all; quit"
   ```

3. **Simulate Edge Detector Suite**:
   ```bash
   vsim -c Edge_Detector_TB -do "run -all; quit"
   ```

4. **View Output Waveforms**: Open generated `.vcd` files (`debouncing circuit.vcd` or `Edge Detector.vcd`) in GTKWave or ModelSim to verify state transitions and output timings against the provided waveform captures in `docs/`.
