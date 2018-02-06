% ������ ����ٶ�����Ԫ�� ���ڱ߽����� ���� ���� �������
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
z = zeros(1,n);  %Ԫ������
z = roadstart(z,200); %��·״̬��ʼ����·��������ֲ�������
cells = z;
vmax = 5;%�������
v = speedstart(cells,vmax); %�ٶȳ�ʼ��
x = 1;%��¼�ٶȺͳ���λ��
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
        %�߽���������������ĩ�������ƽ�����ʹ�ÿ�������
        a = searchleadcar(cells);
        b = searchlastcar(cells);
        [cells,v] = border_control(cells,a,b,v,vmax);
        i = searchleadcar(cells);%�����׳�λ��
        for j = 1:i
            if i-j+1 == n
                [z,v] = leadcarupdate(z,v);
                continue;
            else
                %=======���١����١��������
                if cells(i-j+1)==0%; %�жϵ�ǰλ���Ƿ�ǿ�
                    continue;
                else
                    %=====����
                    v(i-j+1)=min(v(i-j+1)+1,vmax);
                    %=====����
                    k = searchfrontcar((i-j+1),cells);
                    if k == 0
                        d = n-(i-j+1);
                    else
                        d = k-(i-j+1)-1;
                    end
                    v(i-j+1) = min(v(i-j+1),d);
                    %=====�������
                    v(i-j+1) = randslow(v(i-j+1));
                    new_v = v(i-j+1);
                    %====����λ��
                    z(i-j+1)=0;
                    z(i-j+1+new_v)=1;
                    %====�����ٶ�
                    v(i-j+1)=0;
                    v(i-j+1+new_v)=new_v;
                end
            end
        end
        cells = z;
        memor_cells(x,:) = cells;%��¼�ٶȺͳ���λ��
        memor_v(x,:)=v;
        x=x+1;
        set(imh, 'cdata',cells);%����ͼ��
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
xlabel('�ռ�λ��')
ylabel('ʱ�䣨s��')
title('ʱ��ͼ')
for i = 1000:1:3600
    density(i)=sum(memor_cells(i,:)>0)/1000;
    flow(i)=sum(memor_v(i,:))/1000;
end

figure(2)
plot(density,flow,'k.');
xlabel('density')
ylabel('flow')
title('�����ܶ�ͼ')


        
                    
