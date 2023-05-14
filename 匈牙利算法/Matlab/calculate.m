function [results, totalPotential] = calculate(cost_matrix)
    matrix = cost_matrix;
    col = size(matrix, 2);
    row = size(matrix, 1);
    size_ = numel(matrix);
    shape = size(matrix);
    results = [];
    totalPotential = 0;
    result_matrix = matrix;

    % Step 1: 归约
    for index = 1:size(result_matrix, 1)
        row = result_matrix(index, :);
        % 每一行减去本行的最小值
        result_matrix(index, :) = result_matrix(index, :) - min(row);
    end

    for index = 1:size(result_matrix, 2)
        column = result_matrix(:, index);
        % 每一列减去本列的最小值
        result_matrix(:, index) = result_matrix(:, index) - min(column);
    end

    % Step 2: 试指派
    total_covered = 0;
    while total_covered < size_
        % 初始化参数
        zero_locations = (result_matrix == 0);
        zero_locations_copy = zero_locations;
        zero_shape = size(result_matrix);
        covered_rows = [];
        covered_cols = [];
        ticked_row = [];
        ticked_col = [];
        marked_zeros = [];

        % 试指派并标记独立零元素
        while true
            if ~any(zero_locations_copy(:))
                break;
            end
            % 扫描矩阵每一行，找到含0元素最少的行，对任意0元素标记（独立零元素），划去标记0元素（独立零元素）所在行和列存在的0元素
            min_row_zero_nums = [9999999, -1];
            for index = 1:size(zero_locations_copy, 1)
                row = zero_locations_copy(index, :);
                row_zero_nums = sum(row);
                if row_zero_nums < min_row_zero_nums(1) && row_zero_nums ~= 0
                    min_row_zero_nums = [row_zero_nums, index];
                end
            end
            % 最少0元素的行
            row_min = zero_locations_copy(min_row_zero_nums(1), :);
            % 找到此行中任意一个0元素的索引位置即可
            row_indices = find(row_min);
            % 标记该0元素
            marked_zeros(end + 1, :) = [min_row_zero_nums(1), row_indices(1)];
            % 划去该0元素所在行和列存在的0元素
            zero_locations_copy(:, row_indices(1)) = false(zero_shape(1), 1);
            zero_locations_copy(min_row_zero_nums(1), :) = false(1, zero_shape(2));
        end

        % 无被标记0（独立零元素）的行打勾
        independent_zero_row_list = [];
        for i = 1:size(marked_zeros, 1)
            pos = marked_zeros(i, :);
            independent_zero_row_list(end + 1) = pos(1);
        end
        ticked_row = setdiff(1:zero_shape(1), independent_zero_row_list);

        % 重复3,4直到不能再打勾
        TICK_FLAG = true
        while TICK_FLAG
            TICK_FLAG = false;
            % 对打勾的行中所含0元素的列打勾
            for i = 1:numel(ticked_row)
                row = ticked_row(i);
                % 找到此行
                row_array = zero_locations(row, :);
                % 找到此行中0元素的索引位置
                for j = 1:numel(row_array)
                    if row_array(j) && ~ismember(j, ticked_col)
                        ticked_col(end + 1) = j;
                        TICK_FLAG = true;
                    end
                end
            end

            % 对打勾的列中所含独立0元素的行打勾
            for i = 1:size(marked_zeros, 1)
                row = marked_zeros(i, 1);
                col = marked_zeros(i, 2);
                if ismember(col, ticked_col) && ~ismember(row, ticked_row)
                    ticked_row(end + 1) = row;
                    FLAG = true;
                end
            end
        end

        % 对打勾的列和没有打勾的行画画线
        covered_rows = setdiff(1:zero_shape(1), ticked_row);
        covered_cols = ticked_col;

        single_zero_pos_list = marked_zeros;
        total_covered = numel(covered_rows) + numel(covered_cols);

        % 如果划线总数不等于矩阵的维度需要进行矩阵调整（需要使用未覆盖处的最小元素）
        if total_covered < size_
            % 计算未被覆盖元素中的最小值（m）
            elements = [];
            for row_index = 1:numel(result_matrix(:, 1))
                if ~ismember(row_index, covered_rows)
                    for index = 1:numel(result_matrix(row_index, :))
                        if ~ismember(index, covered_cols)
                            elements(end + 1) = result_matrix(row_index, index);
                        end
                    end
                end
            end
            min_uncovered_num = min(elements);
            % 未被覆盖元素减去最小值m
            for row_index = 1:numel(result_matrix(:, 1))
                if ~ismember(row_index, covered_rows)
                    for index = 1:numel(result_matrix(row_index, :))
                        if ~ismember(index, covered_cols)
                            result_matrix(row_index, index) = result_matrix(row_index, index) - min_uncovered_num;
                        end
                    end
                end
            end

            % 行列划线交叉处加上最小值m
            for row = covered_rows
                for col = covered_cols
                    result_matrix(row, col) = result_matrix(row, col) + min_uncovered_num;
                end
            end
        end
    end

    results = single_zero_pos_list;
    % 计算总期望结果
    value = 0;
    for i = 1:numel(single_zero_pos_list(:, 1))
        row = single_zero_pos_list(i, 1);
        column = single_zero_pos_list(i, 2);
        value = value + matrix(row, column);
    end
    totalPotential = value;
end