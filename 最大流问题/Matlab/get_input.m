function [cost_matrix, s, t, weights] = get_input()
    % 读取用户输入
    fprintf("请输入有向图容量矩阵:（每次输入1行，用空格分隔，输入结束后回车即可）\r\n");
    % 读取矩阵
    cost_matrix = [];
    line = input("", 's');

    while ~isempty(line)
        values = strsplit(line, ' ');
        values = cellfun(@str2num, values);
        cost_matrix = [cost_matrix; values];
        line = input("", 's');
    end

    % 读取用户输入
    fprintf("请输入有向图容量矩阵:（每次输入1行，用空格分隔，输入结束后回车即可）\r\n");
    % 读取矩阵
    cost_matrix2 = [];
    line = input("", 's');

    while ~isempty(line)
        values = strsplit(line, ' ');
        values = cellfun(@str2num, values);
        cost_matrix2 = [cost_matrix2; values];
        line = input("", 's');
    end

    % 找出cost_matrix中非零元素的行列索引和值
    [i, j, v] = find(cost_matrix);

    % 将行列索引和值分别存储为三个矩阵
    temp1 = [i'; j'; v'];

    % 将B转置为你想要的形式
    temp2 = temp1';

    s = temp2(:, 1); % 第一个矩阵是C的第一列
    t = temp2(:, 2); % 第二个矩阵是C的第二列
    weights = temp2(:, 3); % 第三个矩阵是C的第三列
end
