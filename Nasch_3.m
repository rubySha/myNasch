% 单车道 最大速度三个元胞 开口边界条件 加速 减速 随机慢化
clf
clear all

%build the GUI
%define the plot button
plotbutton = uicontrol('style', 'pushbutton',...
                       'string', 'Run',...
                       'fontsize',12,...
                       'position',[100,400,50,20],...
                       'callback','run=1;');
%define the stop button
erasebutton  = uicontrol('style', 'pushbutton',...
                         'string', 'Stop',...
                         'fontsize',12,...
                         'position',[200,400,50,20],...
                         'callback','freeze=1;');
%define the quit button
quitbutton  = uicontrol('style', 'pushbutton',...
                        'string', 'Quit',...
                        'fontsize',12,...
                        'position',[300,400,50,20],...
                        'callback','stop=1;close;');
number  = uicontrol('style', 'text',...
                    'string', '1',...
                    'fontsize',12,...
                    'position',[20,400,50,20]);
%CA setup
n = 1000;
z = zeros(1,n);  %元胞个数
z = roadstart(z,200); %道路状态初始化，路段上随机分布五辆车
cells = z;
vmax = 5;%最大速速
v = speedstart(cells,vmax); %速度初始化
x = 1;%记录速度和车辆位置
memor_cells = zeros(3600,n);
memor_v = zeros(3600,n);
imh = imshow(cells);
%set(imh, 'erasemode', 'none');
axis equal
axis tight
stop = 0;
run = 0;
freeze = 0;
while(stop == 0 && x < 11502)
    if(run ==1)
        %边界条件处理，搜索首末车，控制进出，使用开口条件
        a = searchleadcar(cells);
        b = searchlastcar(cells);
        [cells,v] = border_control(cells,a,b,v,vmax);
        i = searchleadcar(cells);%搜索首车位置
        for j = 1:i
            if i-j+1 == n
                [z,v] = leadcarupdate(z,v);
                continue;
            else
                %=======加速、减速、随机慢化
                if cells(i-j+1)==0%; %判断当前位置是否非空
                    continue;
                else
                    %=====加速
                    v(i-j+1)=min(v(i-j+1)+1,vmax);
                    %=====减速
                    k = searchfrontcar((i-j+1),cells);
                    if k == 0
                        d = n-(i-j+1);
                    else
                        d = k-(i-j+1)-1;
                    end
                    v(i-j+1) = min(v(i-j+1),d);
                    %=====随机慢化
                    v(i-j+1) = randslow(v(i-j+1));
                    new_v = v(i-j+1);
                    %====更新位置
                    z(i-j+1)=0;
                    z(i-j+1+new_v)=1;
                    %====跟新速度
                    v(i-j+1)=0;
                    v(i-j+1+new_v)=new_v;
                end
            end
        end
        cells = z;
        memor_cells(x,:) = cells;%记录速度和车辆位置
        memor_v(x,:)=v;
        x=x+1;
        set(imh, 'cdata',cells);%跟新图像
        pause(0.2);
        stepnumber = 1 + str2num(get(number, 'string'));
        set(number, 'string', num2str(stepnumber))
    end
    if freeze == 1
        run = 0;
        freeze = 0;
    end
    drawnow
end

figure(1)
for l = 3100:1:3600
    for k = 1:1:1000
        if memor_cells(l,k) > 0
            plot(k,l,'k.');
            hold on;
        end
    end
end
xlabel('空间位置')
ylabel('时间（s）')
title('时空图')
for i = 1000:1:3600
    density(i)=sum(memor_cells(i,:)>0)/1000;
    flow(i)=sum(memor_v(i,:))/1000;
end

figure(2)
plot(density,flow,'k.');
xlabel('density')
ylabel('flow')
title('流量密度图')


        
                    
