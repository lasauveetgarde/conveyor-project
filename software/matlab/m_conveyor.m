clc
close all
clear all

global s
global needspeed
global warningpress
global motorspeed
global all_color
global usertabl
global go
global fig
global f2

delete(instrfind)
s = serialport('COM4', 9600);

% colourlist = {'Red','Yellow','Light blue','Blue','Green','Purple','Pink'};
% [indx,tf] = listdlg('ListString',colourlist);
indx = [1, 2, 5, 6, 7];

% ab = inputdlg({'Input min weight','Input max weight'},'Ввод данных', [1 50]);
% WW = str2double(ab);
WW = [0; 100];

% cd = inputdlg({'Input min lenght','Input max lenght'},'Ввод данных', [1 50]);
% LL = str2double(cd);
LL = [0; 20];

k=1; total=0; colour=0; coun=1; sumweight=0; start_measurment = 0; cnt=0;...
    end_measurment1 = 0; end_measurment2 = 0; needspeed=1; i = 1; j=1; m=2;...
    motorspeed=5.2333; continue_measurment = 0; go = 1;

datatabl=zeros(8); %%все данные с USB-порта
rgbtabl = zeros(3); %%массив для записи значений цвета в RGB в диапазоне 0-1
hsvtabl = zeros(3); %%массив для записи значений цвета в HSV в диапазоне 0-1
lenghttabl=zeros(2); %%массив для записи значений длины предмета
weighttabl=zeros(1); %%массив для записи значений массы предмета
colorval = zeros(1);
usertabl = cell(5);
usertabl(:,:) = {0};
usertabl {1,1}='Time';
usertabl {1,2}='Weight';
usertabl {1,3}='Color';
usertabl {1,4}='Lenght';

stopdistance = zeros(1);
all_color = zeros(1,7);
data="";

%result display
fig = uifigure('Name','Result window');
fig.Position = [10   400   500   320];
%color LED
ppanel1 = uipanel(fig,'Position',[10 80 80 80]);
lmp = uilamp(ppanel1,'Position',[10 10 60 60]);
lmp.Color = '#000000';

%Color text area
ppanel2 = uipanel(fig,'Position',[10 200 90 30]);
txa1 = uitextarea(ppanel2,'Position',[0 0 90 30],'HorizontalAlignment', 'center');
txa1.Value='nothing';
%Weight text area
ppanel3 = uipanel(fig,'Position',[160 200 90 30]);
txa2 = uitextarea(ppanel3,'Position',[0 0 90 30],'HorizontalAlignment', 'center');
txa2.Value='nothing';
%Lenght text area
ppanel4 = uipanel(fig,'Position',[315 200 90 30]);
txa3 = uitextarea(ppanel4,'Position',[0 0 90 30],'HorizontalAlignment', 'center');
txa3.Value='nothing';
%Speed visible
ppanel5 = uipanel(fig,'Position',[315 20 170 170]);

kb = uiknob(ppanel5,'continuous','Position',[35 20 80 80],...
    'ValueChangedFcn', @(kb,event) knobTurned(kb,motorspeed));
kb.Limits =[0 5.5];
value_speed = uilabel(ppanel5,...
    'Position',[90 145 50 15],...
    'Text','0');
value_speed_mark = uilabel(ppanel5,...
    'Position',[130 145 50 15],...
    'Text','sm*s');

ppanel5 = uipanel(fig,'Position',[10 250 140 30]);
txa4 = uitextarea(ppanel5,'Position',[20 0 140 30],'HorizontalAlignment', 'center');
lmp2 = uilamp(ppanel5,'Position',[3 5 17 17]);
lmp2.Color = '#000000';
ppanel6 = uipanel(fig,'Position',[160 250 145 30]);
txa5 = uitextarea(ppanel6,'Position',[20 0 140 30],'HorizontalAlignment', 'center');
lmp3 = uilamp(ppanel6,'Position',[3 5 17 17]);
lmp3.Color = '#000000';
ppanel7 = uipanel(fig,'Position',[315 250 150 30]);
txa6 = uitextarea(ppanel7,'Position',[20 0 140 30],'HorizontalAlignment', 'center');
lmp4 = uilamp(ppanel7,'Position',[3 5 17 17]);
lmp4.Color = '#000000';

pan6 = uipanel(fig,'Position',[160 100 100 30]);
btn6=uibutton(pan6,'push','Text', 'Save data file',...
    'ButtonPushedFcn', @(btn6,event) PushButtonFile(btn6,usertabl, f2),...
    'Position', [0 0 100 30 ]);
pan7 = uipanel(fig,'Position',[160 50 100 30]);
btn7=uibutton(pan7,'push','Text', 'Stop program',...
    'ButtonPushedFcn', @(btn7,event) PushButtonStop(btn7,go,fig,s),...
    'Position', [0 0 100 30 ]);

%Controlling display

f=figure('Name','Control Speed', 'NumberTitle', 'Off','MenuBar', 'none');
f.Position = [525   400   550   350];
%Slider to set speed
sliderdata=uicontrol(f,'BackgroundColor','#ABB2B1','style','Slider','Min',0,'Max',1,...
    'Value',1,'units','normalized');
sliderdata.Position = [0.1 0.1 0.05 0.8];
%Stop button
pan1 = uipanel(f,'Position',[0.17 0.2 0.2 0.1]);
btn1=uicontrol(pan1,'style','pushbutton',...
    'String','Stop','CallBack',@PushButton1, 'Position', [1.6 1.2 108 38.79 ]);
%Start  with max speed button
pan2 = uipanel(f,'Position',[0.17 0.35 0.2 0.1]);
btn2=uicontrol(pan2,'style','pushbutton',...
    'String','Max speed','CallBack', @PushButton2, 'Position', [1.6 1.2 108 38.79 ]);
%Start  with set speed button
pan3 = uipanel(f,'Position',[0.17 0.50 0.2 0.1]);
btn3=uicontrol(pan3,'style','pushbutton', 'String','Set speed',...
    'CallBack', {@PushButton3, sliderdata, needspeed, motorspeed},...
    'Position', [1.6 1.2 108 38.79 ]);
%User control button
pan4 = uipanel(f,'Position',[0.17 0.7 0.3 0.1]);
btn4=uicontrol(pan4,'style','pushbutton', 'String','Manual control',...
    'CallBack', {@PushButton4, warningpress}, ...
    'Position', [1.6 1.7 164 38.79 ]);
%Auto control button
pan5 = uipanel(f,'Position',[0.53 0.7 0.3 0.1]);
bt5=uicontrol(pan5,'style','pushbutton', 'String','Automatic control',...
    'CallBack', {@PushButton5, warningpress},...
    'Position', [1.6 1.7 164 38.79 ]);

f2=figure('Name','Color pie', 'NumberTitle', 'Off','MenuBar', 'none');
f2.Position = [1100   400   350   250];
t = tiledlayout(1,1,'TileSpacing','compact');
ax1 = nexttile;
% result_pie_color=pie(all_color);
colormap([0.857 0 0;
    0.9290 0.6940 0.1250;
    0.3010 0.7450 0.9330;
    0 0.4470 0.7410;
    0.4660 0.6740 0.1880;
    0.4940 0.1840 0.5560;
    0.982 0.668 0.826;
    ])


write(s, 1, "string");
pause(2)
write(s, 1, "string");

while (go)
    pie(ax1,all_color)
    data = read(s,28,"string");
    datatabl(i,:)=double(split(data))';
    kb.Value=motorspeed;
    value_speed.Text=num2str(motorspeed);
    
    if warningpress == 1
        write(s, needspeed, "string");
    else
        stopdistance(i) = datatabl(i,7);
        %масса предмета
        if ((stopdistance(i)>=10)&&(stopdistance(i)<=15)&& (start_measurment==0))
            start_measurment = 1;
            write(s, 2, "string");
            motorspeed=0;
        end
        
        if ((start_measurment == 1)&&(j<=15))
            weighttabl(j) = datatabl(i,1)-100;
            rgbtabl(j, 1) = (datatabl(i,4)-100)./256; %%перевод в диапазон значений 0-1
            rgbtabl(j, 2)= (datatabl(i,5)-100)./256;
            rgbtabl(j, 3)= (datatabl(i,6)-100)./256;
            hsvtabl(j,:)= rgb2hsv(rgbtabl(j, :)); %%перевод из RGB в HSV
            [colour]=what_color(hsvtabl,j);
            colorval(j) = colour;
            j=j+1;
            
        elseif (start_measurment == 1 && end_measurment1 == 0)
            end_measurment1 = 1;
            m = m + 1;
            motorspeed=5.2333;
            
            answer = sum(weighttabl)/15;
            weightanswer=sprintf(num2str(sum(weighttabl)/15));
            txa2.Value=weightanswer;
            
            truecolor = mode(colorval);
            [txa1.Value,lmp.Color]=true_color(truecolor);
            
            usertabl {m,1}=datestr(now,'HH:MM:SS');
            usertabl{m,2}=answer;
            usertabl{m,3}=txa1.Value{1};
            %отображение цвета и его вывод
            if ((answer<WW(1,1)) || (answer>WW(2,1))&&(start_measurment==1))
                txa5.Value  = ('Объект не того веса ');
                lmp3.Color = '#92000a';
            else
                txa5.Value  = ('Объект того веса ');
                lmp3.Color = '#228b22';
            end
            colourfind=find(indx==colour);
            if isempty(colourfind)
                txa4.Value  = ('Объект не того цвета ');
                lmp2.Color = '#92000a';
            else
                txa4.Value  = ('Объект того цвета ');
                lmp2.Color = '#228b22';
            end
            write(s, 1, "string");
            disp('Покинул зону 1');
        end
        
        lenghttabl(i,1) = datatabl(i,3);
        if end_measurment1
            if (lenghttabl(i,1) ~=0)
                cnt=cnt+1;
                continue_measurment = 1;
            elseif lenghttabl(i,1) ==0 && continue_measurment == 1    
                end_measurment2 = 1;
                continue_measurment = 0;
                averagelen = sum(lenghttabl ((i - cnt): length(lenghttabl))) / cnt;
                cathetus= averagelen.*0.42./0.906307;
                Objectlenght= cnt.*motorspeed/5.5-2.*cathetus;
                if Objectlenght<0
                    Objectlenght=0;
                end
                txa3.Value=num2str(Objectlenght);
                usertabl{m,4}=Objectlenght;
                if ((Objectlenght<LL(1,1)) || (Objectlenght>LL(2,1))&&(end_measurment2==1))
                    txa6.Value  = ('Объект не той длины ');
                    lmp4.Color = '#92000a';
                else
                    txa6.Value  = ('Объект той длины ');
                    lmp4.Color = '#228b22';
                end            
                cnt =0;
                Objectlenght =0;
                fprintf('Покинул зону 2 в %s\n', datestr(now,'HH:MM:SS'));
            end
        end
        
        if end_measurment2
            
                % все верно, все сервы в 0
            if (usertabl{m,2}>=WW(1,1))&&(usertabl{m,2}<=WW(2,1))&& (~isempty(colourfind))...
                    && (usertabl{m,4}>=LL(1,1))&&(usertabl{m,4}<=LL(2,1))
                write(s, 5, "string");
                
                %не тот вес, первая серва в положение 45
            elseif ((usertabl{m,2}<WW(1,1))||(usertabl{m,2}>WW(2,1)))&& (~isempty(colourfind))...
                    && (usertabl{m,4}>=LL(1,1))&&(usertabl{m,4}<=LL(2,1))
                write(s, 3, "string");
                
                %не тот цвет, вторая серва в положение 120
            elseif (usertabl{m,2}>=WW(1,1))&&(usertabl{m,2}<=WW(2,1))&& (isempty(colourfind))...
                    && (usertabl{m,4}>=LL(1,1))&&(usertabl{m,4}<=LL(2,1))
                write(s, 4, "string");
                
                % длина не та, первая серва в 120
            elseif (usertabl{m,2}>=WW(1,1))&&(usertabl{m,2}<=WW(2,1))&& (~isempty(colourfind))...
                    && ((usertabl{m,4}<LL(1,1))||(usertabl{m,4}>LL(2,1)))
                write(s, 6, "string");
            else
                % вторая серва в положение 45
                write(s, 7, "string");
                disp('Не могу принять решение');
            end
            start_measurment = 0;
            end_measurment1 = 0;
            end_measurment2 = 0;
            j=1;
            txa1.Value='nothing';
            txa2.Value='nothing';
            lmp.Color = '#000000';
        end
    end
    i = i + 1;
end

function PushButton1(src,~)
global needspeed
global motorspeed
needspeed=2;
motorspeed= 0;
end

% start
function PushButton2(src,~)
global needspeed
global motorspeed
needspeed=1;
motorspeed= needspeed*10*2*3.14*0.05*100/60;
end

% set speed
function PushButton3(src,~, sliderdata,~,~)
global needspeed
global motorspeed
needspeed=sliderdata.Value.*255;
motorspeed= sliderdata.Value.*10*2*3.14*0.05*100/60;
end


function PushButton4(src,~,~)
global warningpress
warningpress=1;
end

function PushButton5(src,~,~)
global warningpress
warningpress=0;
end

function PushButtonFile(src, ~, usertabl,f2)
global usertabl
global f2
writecell(usertabl,'usertable.xls', 'WriteMode','overwritesheet')
saveas(f2,'Piechart.png')
disp('я сохранил')
end

function PushButtonStop(src, ~, go, fig,s)
global go
global fig
global s
write(s, 2, "string");
go = 0;
close all
close(fig)
disp('остановка')
end

function [Txcolor] = what_color (tabl,i)
if ((tabl(i, 1)>0) && (tabl(i, 1)<=0.0472))
    Txcolor=1;
elseif ((tabl(i, 1)>0.0472) && (tabl(i, 1)<=0.186))
    Txcolor=2;
elseif ((tabl(i, 1)>0.186) && (tabl(i, 1)<=0.419))
    Txcolor=5;
elseif ((tabl(i, 1)>0.419) && (tabl(i, 1)<=0.538))
    Txcolor=3;
elseif ((tabl(i, 1)>0.538) && (tabl(i, 1)<=0.727))
    Txcolor=4;
elseif ((tabl(i, 1)>0.727) && (tabl(i, 1)<=0.805))
    Txcolor=6;
elseif ((tabl(i, 1)>0.805) && (tabl(i, 1)<=0.966))
    Txcolor=7;
elseif  (tabl(i, 1)<=1)
    Txcolor=1;
else
    Txcolor=7;
end
end

function [Value, lmpColor] = true_color(fcolor)
global all_color
if (fcolor==1)
    Value='red color';
    lmpColor = '#92000a';
    all_color(1)= all_color(1) + 1;
elseif (fcolor==2)
    Value='yellow color';
    lmpColor = '#ffd700';
    all_color(2)= all_color(2) + 1;
elseif (fcolor==5)
    Value='green color';
    lmpColor = '#228b22';
    all_color(5)= all_color(5) + 1;
elseif (fcolor==3)
    Value='light blue color';
    lmpColor = '#6495ed';
    all_color(3)= all_color(3) + 1;
elseif (fcolor==4)
    Value='blue color';
    lmpColor = '#310062';
    all_color(4)= all_color(4) + 1;
elseif (fcolor==6)
    Value='purple color';
    lmpColor = '#7E2F8E';
    all_color(6)= all_color(6) + 1;
elseif (fcolor==7)
    Value='pink color';
    lmpColor = '#ffc0cb';
    all_color(7)= all_color(7) + 1;
end
end

