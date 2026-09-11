% ============================================================
% 03_robust_optimization.m
% 功能：风险调整优化（Mean + lambda*Std）+ Minimax Regret 鲁棒优化
% ============================================================

clear; clc; close all;

% 基础模型
p = [-0.125, 9.025, -50.225];
T = 30 : 0.1 : 33;
P_base = polyval(p, T);

% 异方差噪声模型：低温时波动大，高温时波动小（物理直觉）
sigma_T = 3.0 - 0.25 * (T - 30);

% 蒙特卡洛
num_sim = 10000;
rng(2026);
P_samples = zeros(length(T), num_sim);
for i = 1 : length(T)
    P_samples(i, :) = P_base(i) + sigma_T(i) * randn(1, num_sim);
end

P_mean = mean(P_samples, 2);
P_std  = std(P_samples, 0, 2);

% ---------- 风险调整优化 ----------
lambda_list = [0, 5, 10, 20];
figure('Position', [50, 50, 900, 600]);
hold on;
colors = {'k', 'b', 'g', 'r'};
fprintf('\n========== 风险调整（Mean + lambda*Std）最优温度 ==========\n');
for idx = 1 : length(lambda_list)
    lambda = lambda_list(idx);
    P_risk = P_mean + lambda * P_std;
    plot(T, P_risk, 'LineWidth', 2, 'Color', colors{idx}, ...
         'DisplayName', sprintf('lambda = %d', lambda));
    [~, min_idx] = min(P_risk);
    plot(T(min_idx), P_risk(min_idx), 'o', 'MarkerSize', 8, ...
         'MarkerFaceColor', colors{idx}, 'Color', colors{idx});
    fprintf('lambda = %2d  -> 最优设定值 = %.1f C (风险调整成本 = %.2f kW)\n', ...
            lambda, T(min_idx), P_risk(min_idx));
end
xlabel('Cooling Tower Outlet Temperature Setpoint (C)', 'FontSize', 12);
ylabel('Risk-Adjusted Cost (kW)', 'FontSize', 12);
title('Optimal Setpoint Shift under Different Risk Aversion (lambda)', 'FontSize', 13);
legend('Location', 'northwest', 'FontSize', 10);
grid on; hold off;
saveas(gcf, 'results/figures/fig4_risk_aversion.png');

% ---------- Minimax Regret ----------
num_scenarios = 5000;
P_scenario = zeros(length(T), num_scenarios);
for i = 1 : length(T)
    P_scenario(i, :) = P_base(i) + sigma_T(i) * randn(1, num_scenarios);
end
best_cost = min(P_scenario, [], 1);
regret_matrix = zeros(length(T), num_scenarios);
for i = 1 : length(T)
    regret_matrix(i, :) = P_scenario(i, :) - best_cost;
end
max_regret = max(regret_matrix, [], 2);
[~, min_max_regret_idx] = min(max_regret);
T_minimax = T(min_max_regret_idx);

figure('Position', [50, 50, 800, 500]);
plot(T, max_regret, 'b-', 'LineWidth', 2.5);
hold on;
plot(T(min_max_regret_idx), max_regret(min_max_regret_idx), ...
     'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
xlabel('Cooling Tower Outlet Temperature Setpoint (C)', 'FontSize', 12);
ylabel('Maximum Regret (kW)', 'FontSize', 12);
title('Minimax Regret: Minimizing the Worst-Case Loss', 'FontSize', 13);
grid on;
legend('Max Regret Curve', sprintf('Optimal: %.1f C', T_minimax), ...
       'Location', 'northwest');
hold off;
saveas(gcf, 'results/figures/fig5_minimax_regret.png');

fprintf('\nMinimax Regret 最优温度设定值 = %.1f C\n', T_minimax);

% ---------- 30C vs 31C 箱线图 ----------
T1_idx = find(T == 30);
T2_idx = find(abs(T - 31) < 0.01);
data_30 = P_samples(T1_idx, :);
data_31 = P_samples(T2_idx, :);

figure('Position', [100, 100, 600, 700]);
boxplot([data_30', data_31'], {'30C (Det. Optimum)', '31C (Robust Candidate)'}, ...
        'Colors', 'k', 'Symbol', 'o');
ylabel('Total Power Consumption (kW)', 'FontSize', 12);
title('Power Distribution: Deterministic Optimum vs Robust Candidate', 'FontSize', 13);
grid on;
saveas(gcf, 'results/figures/fig6_boxplot_comparison.png');

fprintf('\n========== 30C vs 31C 风险对比 ==========\n');
fprintf('30C : 均值=%.2f kW, 标准差=%.2f kW, 90%%分位=%.2f kW\n', ...
        mean(data_30), std(data_30), prctile(data_30, 90));
fprintf('31C : 均值=%.2f kW, 标准差=%.2f kW, 90%%分位=%.2f kW\n', ...
        mean(data_31), std(data_31), prctile(data_31, 90));

disp('所有图已保存到 results/figures/');
