function result = match(result_matrix)
% 函数用于计算结果
[m,n] = size(result_matrix);
result = [];
p = 1;
q = 1;
temp = length(find(result_matrix==0));
while (temp~=0)
    %% 处理1个0
    for i = 1:m
        zero = length(find(result_matrix(i,:)==0));
        if zero == 1
            single_zero_row(p) = i;% 只有1个0的行
            single_zero_row(p) = find(result_matrix(i,:)==0);% 对应的列
            result(i) = find(result_matrix(i,:)==0);
            p = p+1;
        end
    end
    
    for j = 1:n
        zero = length(find(result_matrix(:,j)==0));
        if zero == 1
            col_single_zero(q) = j;
            row_col_single_zero(q) = find(result_matrix(:,j)==0);
            result(row_col_single_zero(q)) = j;
            q = q+1;
        end
    end
    row_delete = [single_zero_row row_col_single_zero];
    column_delete = [single_zero_row col_single_zero];
    result_matrix(row_delete,:) = result_matrix(row_delete,:)+inf;
    result_matrix(:,column_delete) = result_matrix(:,column_delete)+inf;
    
    %% 处理多余1个0
    for i = 1:m
        zero = find(result_matrix(i,:)==0);
        if length(zero) ~= 0
            result(i) = zero(1);
            result_matrix(i,:) = result_matrix(i,:) + inf;
            result_matrix(:,zero(1)) = result_matrix(:,zero(1)) + inf;
        end
    end
    
    temp = length(find(result_matrix==0));
end
end
