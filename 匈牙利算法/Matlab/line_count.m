function [line_sum,row_index,row_sum,column_index,column_sum,row_index2,row_sum2,matrix_out] = line_count(matrix)
% 对处理过的矩阵进行划线统计
% line_sum是划线总数,row_sum是统计行划了几条线，column_sum是统计列划了几条线，matrix_out是看最后画完线的矩阵
[m,n] = size(matrix); %统计矩阵的维度m*n
line_sum = 0;%存放划0的数量

%% 处理行
row_index = [];
j = 1;
for i=1:m
    a = length(find(matrix(i,:)==0));
    if a>1
        line_sum = line_sum + 1;
        row_index(j) = i;
        j = j + 1;
    end
end
row_sum = length(row_index);
matrix(row_index,:) =[]; %将输入矩阵删除掉行中含不少于2个0的行

%% 处理列
column_index = [];
k = 1;
for i=1:n
    b = length(find(matrix(:,i)==0));
    if b>1
        line_sum = line_sum +1;
        column_index(k) = i;
        k = k + 1;
    end
end
column_sum = length(column_index);
matrix(:,column_index) = [];
        
%% 处理只有一个0
[m,~] = size(matrix);%上一步处理完的矩阵有可能不是方阵
row_index2 = [];
j = 1;
for i=1:m
    a = length(find(matrix(i,:)==0));
    if a == 1
        line_sum = line_sum +1;
        row_index2(j) = i;
        j = j+1;
    end
end
row_sum2 = length(row_index2);
matrix(row_index2,:) = [];
matrix_out = matrix;
end   
