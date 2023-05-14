function [pro_rc] = reduction(matrix)
% Step 1: 归约
m = length(matrix);
% 行归约
for i=1:m
    rowi_min = min(matrix(i,:));
    matrix(i,:) = matrix(i,:)-rowi_min;
end
% 列归约
for i=1:m
    columni_min = min(matrix(:,i));
    matrix(:,i) = matrix(:,i)-columni_min;
end
pro_rc = matrix;
end
