# CoolingTower-Robust-Optimization

基于论文《基于HOA的建筑集中空调系统冷却塔出水温度优化控制研究》图8a的复现与鲁棒优化扩展。

## 项目简介

本项目分为三个递进层次：

1. 确定性拟合：复现论文图8a中"冷却塔出水温度设定值与总能耗"的关系曲线
2. 蒙特卡洛模拟：分析外界气温波动下最优设定值的稳定性
3. 鲁棒优化：引入风险调整（Mean + lambda*Std）和 Minimax Regret，寻找抗干扰的保守最优值

## 核心结论

| 优化视角 | 最优温度 | 平均能耗 | 说明 |
| :--- | :--- | :--- | :--- |
| 传统确定性 | 30.0 C | 108.02 kW | 理想模型下最省电 |
| 鲁棒推荐 | 30.8~31.0 C | 108.8~109.1 kW | 牺牲约1kW，换取稳定性 |
| Minimax Regret | 31.0 C | 109.10 kW | 保证最坏情况下不吃大亏 |

## 环境要求

- GNU Octave 7.0+ 或 MATLAB R2020a+

## 快速开始

在 Octave/MATLAB 中运行：

    cd CoolingTower-Robust-Optimization
    run('src/run_all.m')

## 文件结构

    CoolingTower-Robust-Optimization/
    ├── src/
    │   ├── step1_deterministic_fit.m      # 确定性拟合（复现论文图8a）
    │   ├── step2_monte_carlo_analysis.m   # 蒙特卡洛稳定性分析
    │   ├── step3_robust_optimization.m    # 鲁棒优化
    │   └── run_all.m                      # 一键运行
    ├── data/
    │   └── fig8a_data.txt                 # 论文原始数据点
    ├── results/figures/                   # 输出图片
    ├── docs/                              # 方法论文档
    └── README.md

## 方法论

### 确定性拟合

使用二次多项式拟合论文图8a提取的4个数据点：

    y = -0.125x^2 + 9.025x - 50.225

### 鲁棒优化（风险调整）

引入风险厌恶系数 lambda，目标函数重构为：

    J = mu + lambda * sigma

其中 mu 为平均能耗，sigma 为标准差。lambda 越大，越倾向于选择波动小的设定值。

### Minimax Regret

最小化最坏情况下的后悔损失：

    min_x max_epsilon [ f(x, epsilon) - min_x' f(x', epsilon) ]

## 许可证

MIT License