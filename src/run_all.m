% ============================================================
% run_all.m
% 功能：一键运行冷却塔鲁棒优化全流程
% ============================================================

disp('===== 冷却塔鲁棒优化全流程开始 =====');
disp(' ');

% 强制切换到项目根目录（解决 Octave 在 Windows 下的路径寻址 Bug）
cd('D:\CoolingTower-Robust-Optimization');

% 强制检查并创建文件夹（如果已经存在，它会直接跳过，不报错）
if ~exist('results', 'dir')
    mkdir('results');
end
if ~exist('results/figures', 'dir')
    mkdir('results/figures');
end

% 把 src 文件夹添加到搜索路径
addpath(genpath('src'));

disp('>>> 第1步：确定性拟合（复现论文图8a）');
step1_deterministic_fit;
disp(' ');

disp('>>> 第2步：蒙特卡洛模拟（最优值稳定性分析）');
step2_monte_carlo_analysis;
disp(' ');

disp('>>> 第3步：鲁棒优化（风险调整 + Minimax Regret）');
step3_robust_optimization;
disp(' ');

disp('===== 全流程运行完毕！请查看 results/figures/ =====');
