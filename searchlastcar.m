function [location_lastcar]=searchlastcar(matrix_cells)
%ËÑË÷Î²³µÎ»ÖÃ
for i = 1:length(matrix_cells)
    if matrix_cells(i)~= 0
        location_lastcar = i;
        break;
    else
        location_lastcar = length(matrix_cells);
    end
end