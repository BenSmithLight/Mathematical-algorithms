% 单纯形法求解线性规划
clc, clear;

%% 获取用户输入
disp('请输入矩阵信息：')
disp('系数矩阵示例：[2 2 1 0 0;4 0 0 1 0;0 5 0 0 1]')
disp('常数项示例：[12;16;15]')
% 上述两个合并在一起作为增广矩阵
disp('目标函数系数示例：[-2;-3;0;0;0]')

A = input('请输入约束方程组系数矩阵：');
b = input('请输入约束方程组常数项：');
c = input('请输入目标函数系数（归一化为min类型）：');

% 测试数据
% A = [2 2 1 0 0; 4 0 0 1 0; 0 5 0 0 1];
% b = [12 16 15]';
% c = [-2 -3 0 0 0]';

%% 调用函数，求解线性规划，输出计算结果
[xm, fm] = model3(A, b, c);

% 输出结果
fprintf('\n最优解为：')

for i = 1:length(xm)
    fprintf('x%d=%d ', i, xm(i));
end

fprintf('')
fprintf('\n最优函数值为：%d\n', -fm);
