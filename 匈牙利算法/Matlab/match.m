function [asig] = match(matrix)
% 函数用于最后的分配
% 函数输入是最后的0划线数量等于矩阵的维度的最终被处理过的矩阵
% 函数的输出是最后的分配方案，[2 3 1 4]表示User1被分配到Task2，依次类推
[m,n] = size(matrix);
asig = [];% 存放决策的矩阵,[4 2 3 1]表示第一个用户被分配到任务4，以此类推
p = 1;
q = 1;
temp = length(find(matrix==0));
while (temp~=0)
    %% 处理1个0
    for i = 1:m
        zero = length(find(matrix(i,:)==0));
        if zero == 1
            row_0_1(p) = i;% row_0_1表示只有1个0的行
            column_row_0_1(p) = find(matrix(i,:)==0);% column_row_0_1表示只与一个0的行对应的列
            asig(i) = find(matrix(i,:)==0);% 用户i被分配任务
            p = p+1;
        end
    end
    
    for j = 1:n
        zero = length(find(matrix(:,j)==0));
        if zero == 1
            column_0_1(q) = j;
            row_column_0_1(q) = find(matrix(:,j)==0);
            asig(row_column_0_1(q)) = j;% 任务可被分配
            q = q+1;
        end
    end
    row_delete = [row_0_1 row_column_0_1];
    column_delete = [column_row_0_1 column_0_1];
    matrix(row_delete,:) = matrix(row_delete,:)+inf;
    matrix(:,column_delete) = matrix(:,column_delete)+inf;
    
    %% 处理多余1个0
    for i = 1:m
        zero = find(matrix(i,:)==0);
        if length(zero) ~= 0
            asig(i) = zero(1);
            matrix(i,:) = matrix(i,:) + inf;
            matrix(:,zero(1)) = matrix(:,zero(1)) + inf;
        end
    end
    
    temp = length(find(matrix==0));
end
end
