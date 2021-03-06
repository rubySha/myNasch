function [matrix_cells_start]=roadstart(matrix_cells,n)
%道路上的车辆初始状态，元胞矩阵随机为0或1，matrix_cells初始将矩阵，n为初始车辆数
k = length(matrix_cells);
z = round(k*rand(1,n));
for i = 1:n
    j = z(i);
    if j == 0
        matrix_cells(i) = 0;
    else
        matrix_cells(i) = 1;
    end
end
matrix_cells_start = matrix_cells;