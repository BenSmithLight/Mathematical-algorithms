function [total_covered, covered_rows, row_sum, covered_cols, column_sum, single_zero_row, row_sum2, matrix_out] = put_line(matrix)
    [row, col] = size(matrix); % 获取矩阵的shape
    total_covered = 0; % 画线的总数

    %% 找出0的个数大于1的行数
    covered_rows = [];
    index = 1;

    for i = 1:row % 检查一行中包含的0的个数
        num_zero = length(find(matrix(i, :) == 0));

        if num_zero > 1
            total_covered = total_covered + 1;
            covered_rows(index) = i;
            index = index + 1;
        end

    end

    row_sum = length(covered_rows);
    matrix(covered_rows, :) = [];

    %% 找出0的个数大于1的列数
    covered_cols = [];
    k = 1;

    for i = 1:col % 检查一列中包含的0的个数
        num_zero = length(find(matrix(:, i) == 0));

        if num_zero > 1
            total_covered = total_covered +1;
            covered_cols(k) = i;
            k = k + 1;
        end

    end

    column_sum = length(covered_cols);
    matrix(:, covered_cols) = [];

    %% 行和列只有一个0的行数
    [row, ~] = size(matrix); %上一步处理完的矩阵有可能不是方阵
    single_zero_row = [];
    index = 1;

    for i = 1:row
        num_zero = length(find(matrix(i, :) == 0));

        if num_zero == 1
            total_covered = total_covered +1;
            single_zero_row(index) = i;
            index = index + 1;
        end

    end

    row_sum2 = length(single_zero_row);
    matrix(single_zero_row, :) = [];
    matrix_out = matrix;
end
