clc;
clear;

% 主程序：匈牙利算法

%% 用户输入
cost_matrix = get_input();

%% Step 1: 归约
[x, y] = size(cost_matrix);
result_matrix = cost_matrix;
cost_bak = result_matrix;
[m, ~] = size(result_matrix);

row = length(result_matrix);
% 行归约
for i = 1:row
    row_min = min(result_matrix(i, :));
    result_matrix(i, :) = result_matrix(i, :) - row_min;
end

% 列归约
for i = 1:row
    col_min = min(result_matrix(:, i));
    result_matrix(:, i) = result_matrix(:, i) - col_min;
end

%% Step 2: 试指派
[total_covered, covered_rows, row_sum, covered_cols, column_sum, single_zero_row, row_sum2, matrix_out] = put_line(result_matrix);

%% Step 3: 矩阵变换
while (total_covered < m)
    rest_value = min(matrix_out(~isinf(matrix_out))); % 找到没有被覆盖的最小值
    uncovered_rows = setdiff(1:m, [covered_rows single_zero_row]); % 找到没有被覆盖的行
    result_matrix(uncovered_rows, :) = result_matrix(uncovered_rows, :) - rest_value; % 没有被覆盖的行减去最小值
    result_matrix(:, covered_cols) = result_matrix(:, covered_cols) + rest_value; % 被覆盖的列加上最小值
    % 重复Step2和3
    [total_covered, covered_rows, row_sum, covered_cols, column_sum, single_zero_row, row_sum2, matrix_out] = put_line(result_matrix);
end

%% 计算COST
result = match(result_matrix);

if x ~= y
    del_index = x + 1:1:x + y - 1;
    result(del_index) = [];
end

%% 输出计算结果
cost_sum = 0;
n = length(result);
disp([newline, '最优解为：'])

for i = 1:n
    cost_sum = cost_sum + cost_bak(i, result(i));
    fprintf(' x_%s%s=', num2str(i), num2str(result(1)));
    fprintf('1');
end

disp([newline, '最优值为：', num2str(cost_sum)])
