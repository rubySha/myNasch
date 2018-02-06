function [new_matrix_cells, new_v] = border_control(matrix_cells,a,b,v,vmax)
%边界条件，开口边界，控制车辆出入
%出口边界，若头车在道路边界，则一定该路0.9离去
n = length(matrix_cells);
if a == n
    rand('state', sum(100*clock)*rand(1));
    p_1 = rand(1);
    if p_1 <= 1
        matrix_cells(n) = 0;
        v(n) = 0;
    end
end
%入口边界，泊松分布到达，1s内平均到达车辆数为q,t为1s
if b>vmax
    t = 1;
    q = 0.25;
    x = 1;
    p = (q*t)^exp(-q*t)/prod(x);
    rand('state', sum(100*clock)*rand(1));
    p_2 = rand(1);
    if p_2 <= p
        m = min(b-vmax,vmax);
        matrix_cells(m) = 1;
        v(m) = m;
    end
end
new_matrix_cells = matrix_cells;
new_v = v;