function cost_matrix = get_input()
    % 读取用户输入
    n = input("请输入方阵的阶数 n:");
    fprintf("请输入%d行%d列的矩阵:（每次输入1行，用空格分隔）\n", n, n);
    % 读取矩阵
    cost_matrix = zeros(n);
    for i = 1:n
        line = input("", 's');
        values = strsplit(line, ' ');
        values = cellfun(@str2num, values);
        cost_matrix(i, :) = values;
    end
end