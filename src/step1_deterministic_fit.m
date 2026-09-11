% ============================================================
% 01_deterministic_fit.m
% 复现论文：基于HOA的冷却塔出水温度与能耗关系
% 作者：吕佳骏
% 日期：2026年9月6日
% 功能：从论文图8a提取数据点，二次多项式拟合，生成平滑曲线
% ============================================================

% 第一步：从论文图8a读取关键数据点（温度设定值 -> 总能耗）
T_data = [30, 31, 32, 33];
P_data = [108, 109.5, 110.5, 111.5];  % 从论文图8a读出的近似值

% 第二步：用二次多项式拟合，生成平滑曲线
p = polyfit(T_data, P_data, 2);  % 2次多项式拟合

% 第三步：生成更密的温度点，画出拟合后的曲线
T_fine = 30:0.1:33;  % 从30到33，步长0.1
P_fine = polyval(p, T_fine);  % 计算拟合曲线上每个点的总能耗

% 第四步：画图
figure('Position', [100, 100, 800, 600]);  % 新增：固定窗口大小
plot(T_fine, P_fine, 'b-', 'LineWidth', 2);
xlabel('Cooling Tower Outlet Temperature Setpoint (°C)');
ylabel('Total Power Consumption (kW)');
title('Cooling Tower Temperature vs Total Power (Reconstructed from Fig 8a)');
grid on;

% 在图上叠加显示原始数据点（用红色圆圈标记）
hold on;
plot(T_data, P_data, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
legend('Fitted Curve', 'Data Points');
hold off;

% 输出拟合结果
disp('Fitted polynomial coefficients:');
disp(p);
disp('Total power at 30°C:');
P_at_30 = polyval(p, 30);
disp(P_at_30);
disp('Total power at 33°C:');
P_at_33 = polyval(p, 33);
disp(P_at_33);

% 保存图片到项目文件夹
saveas(gcf, 'results/figures/fig1_deterministic_fit.png');
disp('图已保存到 results/figures/fig1_deterministic_fit.png');
