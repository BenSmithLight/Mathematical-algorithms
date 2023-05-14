clc;
clear;

% 主程序：匈牙利算法
% 矩阵由用户输入

%% 用户输入
disp('请确定您要求解的问题是：极小化指派问题/人数与任务数相等问题。');

% 提示用户输入效率矩阵
disp('请输入效率矩阵：');
disp('示例1：[3 8 2 10 3; 8 7 2 9 7; 6 4 2 7 5; 8 4 2 3 5; 9 10 6 9 10]')
disp('示例2：[12 7 9 7 9; 8 9 6 6 6; 7 17 12 14 9; 15 14 6 6 10; 4 10 7 10 9]')

% 获取用户输入的效率矩阵
COST = input('请输入一个矩阵：');

%% 开始计算
[x,y] = size(COST);
COST_P = COST;
COST_bak = COST_P;
[m,~] = size(COST_P);

%% Step 1: 归约
COST_P = reduction(COST_P);
%% Step 2: 试指派：使用最少数量的划线覆盖矩阵中所有的0元素
[line_sum,row_index1,row_sum1,column_index,column_sum,row_index2,row_sum2,matrix_out] = line_count(COST_P);
%% Step 3: 矩阵变换
while (line_sum < m)
    rest_min = min(min(matrix_out));  % 找到没有被覆盖的最小值，将没有被覆盖的每行减去最小值，被覆盖的每列加上最小值。转到上一步。
    row_num = 1:1:m;
    row_index = sort([row_index1 row_index2]);
    row_num(row_index) = [];  % 找到没有被覆盖的行
    COST_P(row_num,:) = COST_P(row_num,:) - rest_min;  % 没有被覆盖的行减去最小值
    COST_P(:,column_index) = COST_P(:,column_index) + rest_min;  % 被覆盖的列加上最小值
    [line_sum,row_index1,row_sum1,column_index,column_sum,row_index2,row_sum2,matrix_out] = line_count(COST_P);
end
%% 计算COST
[asig] = match(COST_P);
if x ~= y
    del_index =x+1:1:x+y-1;
    asig(del_index) = [];
end
%% 输出计算结果
cost_sum = 0;
n = length(asig);
disp('最优解为：')
for i = 1:n
    cost_sum = cost_sum + COST_bak(i,asig(i));
    fprintf(' x_%s%s =', num2str(i), num2str(asig(1)));
    fprintf('1');
end
disp([newline, '最优值为：', num2str(cost_sum)])
