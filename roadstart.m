function [matrix_cells_start]=roadstart(matrix_cells,n)
%��·�ϵĳ�����ʼ״̬��Ԫ���������Ϊ0��1��matrix_cells��ʼ������nΪ��ʼ������
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