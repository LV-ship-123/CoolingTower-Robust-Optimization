% ============================================================
% 02_monte_carlo_analysis.m
% 功能：蒙特卡洛模拟，分析外界气温波动下最优设定值的稳定性
% ============================================================

clear; clc; close all;

% 基础模型（来自01_deterministic_fit的拟合结果）
p = [-0.125, 9.025, -50.225];
T = 30 : 0.1 : 33;
P_base = polyval(p, T);

% 蒙特卡洛参数
num_sim = 5000;
sigma = 1.5;      % 噪声标准差，模拟外界气温波动（kW）
rng(2026);        % 固定种子，保证结果可复现

% 核心循环：每次模拟找出最优温度
opt_T = zeros(num_sim, 1);
for i = 1 : num_sim
    noise = sigma * randn(size(T));
    P_noisy = P_base + noise;
    [~, idx] = min(P_noisy);
    opt_T(i) = T(idx);
end

% 统计鲁棒指标
opt_mean   = mean(opt_T);
opt_median = median(opt_T);
opt_std    = std(opt_T);
p5  = prctile(opt_T, 5);
p95 = prctile(opt_T, 95);
prob_at_30 = sum(opt_T == 30) / num_sim * 100;

fprintf('========== 蒙特卡洛统计结果 (sigma = %.2f kW) ==========\n', sigma);
fprintf('确定性最优温度（无噪声）        : 30.00 C\n');
fprintf('鲁棒推荐温度（中位数）          : %.2f C\n', opt_median);
fprintf('最优温度波动标准差              : %.3f C\n', opt_std);
fprintf('90%% 置信区间                    : [%.2f, %.2f] C\n', p5, p95);
fprintf('恰好选到30度的概率              : %.1f %%\n', prob_at_30);

% 图2：最优设定值分布直方图（Octave 完美兼容版）
figure('Position', [100, 100, 800, 600]);

% 直接调用 Octave 自带的 hist 画直方图
hist(opt_T, 30);

% 美化直方图颜色（可选）
h = findobj(gca, 'Type', 'patch');
set(h, 'FaceColor', [0.2, 0.6, 0.8], 'EdgeColor', 'white');

xlabel('Cooling Tower Outlet Temperature Setpoint (C)', 'FontSize', 12);
ylabel('Frequency', 'FontSize', 12);
title('Distribution of Optimal Setpoint under Ambient Fluctuation (5000 runs)', 'FontSize', 13);
grid on; hold on;

% 手动画两条竖线（解决 Octave 没有 xline 函数的问题）
yl = ylim;
plot([30 30], yl, 'r-', 'LineWidth', 2.5);
plot([opt_median opt_median], yl, 'g--', 'LineWidth', 2.5);

legend('Distribution', 'Deterministic Optimum (30C)', ...
       sprintf('Robust Median (%.2fC)', opt_median), 'Location', 'northeast');
hold off;

% 保存图片
saveas(gcf, 'results/figures/fig2_monte_carlo_distribution.png');
disp('图2已保存到 results/figures/');

% 图3：能耗曲线与不确定性带
figure('Position', [100, 100, 800, 600]);
P_matrix = zeros(num_sim, length(T));
for i = 1 : num_sim
    P_matrix(i, :) = P_base + sigma * randn(size(T));
end
P_mean = mean(P_matrix, 1);
P_std  = std(P_matrix, 0, 1);

fill([T, fliplr(T)], [P_mean - P_std, fliplr(P_mean + P_std)], ...
     [0.85, 0.85, 0.95], 'EdgeColor', 'none');
hold on;
plot(T, P_base, 'b-', 'LineWidth', 2.5);
plot(T, P_mean, 'r--', 'LineWidth', 2);
xlabel('Cooling Tower Outlet Temperature Setpoint (C)', 'FontSize', 12);
ylabel('Total Power Consumption (kW)', 'FontSize', 12);
title('Sensitivity Analysis of Power Curve to Ambient Fluctuation', 'FontSize', 13);
legend('Noise Band (mean +/- 1 sigma)', 'Deterministic Curve', ...
       'Mean of Noisy Curves', 'Location', 'northwest');
grid on; hold off;
saveas(gcf, 'results/figures/fig3_uncertainty_band.png');
disp('图3已保存到 results/figures/');
