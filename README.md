# CoolingTower-Robust-Optimization

**A Reproducible Study on Cooling Tower Outlet Temperature and Total Power Consumption**

> Author: june 
> Date: September 2026

---

## 1. Project Overview

This project serves as an academic reproduction and extension of Figure 8a from the paper *"Research on Optimal Control of Cooling Tower Outlet Temperature in Central Air-Conditioning Systems Based on HOA"*.

Beyond the basic deterministic curve fitting, this project introduces **Monte Carlo simulations** and **Robust Optimization** techniques to investigate the stability of the optimal setpoint under ambient temperature fluctuations.

## 2. Methodology & Workflow

The project is structured into three progressive phases:

### Phase 1: Deterministic Fitting (Reproduction)
- Extracted 4 key data points from Figure 8a (T = 30, 31, 32, 33 °C).
- Fitted a quadratic polynomial: `y = -0.125x^2 + 9.025x - 50.225`.
- Verified that total power consumption strictly increases with temperature.

### Phase 2: Monte Carlo Simulation (Uncertainty Analysis)
- Introduced Gaussian noise (`sigma = 1.5 kW`) to simulate ambient temperature fluctuations.
- Conducted 5,000 simulations to observe the distribution of the optimal setpoint.
- Result: The deterministic optimum (30 °C) is highly sensitive to noise.

### Phase 3: Robust Optimization (Risk Aversion & Minimax Regret)
- **Risk-adjusted cost**: `J = mu + lambda * sigma`.
- **Minimax Regret**: Minimized the worst-case loss.
- Found that shifting the setpoint to **30.8~31.0 °C** provides a better trade-off.

## 3. Key Results

| Optimization Criterion | Optimal Setpoint | Average Power | Remarks |
| :--- | :--- | :--- | :--- |
| Deterministic Optimum | 30.0 °C | 108.02 kW | Ideal model, most efficient |
| Robust Candidate | 30.8 ~ 31.0 °C | 108.8 ~ 109.1 kW | Sacrifices ~1 kW for stability |
| Minimax Regret | 31.0 °C | 109.10 kW | Ensures worst-case protection |

## 4. File Structure

```text
CoolingTower-Robust-Optimization/
├── src/
│   ├── step1_deterministic_fit.m      # Step 1: Deterministic fitting
│   ├── step2_monte_carlo_analysis.m   # Step 2: Monte Carlo analysis
│   ├── step3_robust_optimization.m    # Step 3: Robust optimization
│   └── run_all.m                      # One-click execution script
├── data/
│   └── fig8a_data.txt                 # Original data points from paper
├── results/figures/                   # Output figures
└── README.md\

##5. Requirements

GNU Octave 7.0+ or MATLAB R2020a+

(No external toolbox required for basic 5 figures)

##6. How to Run

git clone https://github.com/LV-ship-123/CoolingTower-Robust-Optimization.git

cd CoolingTower-Robust-Optimization

In Octave/MATLAB command window:

run('src/run_all.m')

##7. Future Work

Extend to time-varying wet-bulb temperature (dynamic optimization).

Connect with EnergyPlus for real building load data.

Replace penalty with multi-objective optimization (Pareto front).

##8. License

Academic and research purposes only.
