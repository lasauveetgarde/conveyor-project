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
global f2

delete(instrfind)
s = serialport('COM4', 9600);

% colourlist = {'Red','Yellow','Light blue','Blue','Green','Purple','Orange'};
% [indx,tf] = listdlg('ListString',colourlist);
indx = [1, 2, 6, 7];

% ab = inputdlg({'Input min weight','Input max weight'},'Ввод данных', [1 50]);
% WW = str2double(ab);
WW = [0; 25];

% cd = inputdlg({'Input min lenght','Input max lenght'},'Ввод данных', [1 50]);
% LL = str2double(cd);
LL = [0; 20];

k=1; total=0; colour=0; coun=1; sumweight=0; start_measurment = 0; cnt=0;...
    end_measurment1 = 0; end_measurment2 = 0; needspeed=1; i = 1; j=1; m=2; z=1;...
    motorspeed=5.2333; continue_measurment = 0; go = 1;

datatabl=zeros(8); %%все данные с USB-порта
rgbtabl = zeros(3); %%массив для записи значений цвета в RGB в диапазоне 0-1
hsvtabl = zeros(3); %%массив для записи значений цвета в HSV в диапазоне 0-1
lenghttabl=zeros(2); %%массив для записи значений длины предмета
weighttabl=zeros(1); %%массив для записи значений массы предмета
colorval = zeros(1);
usertabl = cell(5);
usertabl(:,:) = {0};
usertabl {1,1}='TIME';
usertabl {1,2}='LENGHT';
usertabl {1,3}='COLOR';
usertabl {1,4}='WEIGHT';
usertabl {1,5}='SORTING SOLUTION';

stopdistance = [35 35 35 35 35 35 35];
viborka = zeros (1,7);
all_color = zeros(1,7);
data="";
filename = 'usertable.xlsx';

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
    'ButtonPushedFcn', @(btn6,event) PushButtonFile(btn6, filename),...
    'Position', [0 0 100 30 ]);
pan7 = uipanel(fig,'Position',[160 50 100 30]);
btn7=uibutton(pan7,'push','Text', 'Stop program',...
    'ButtonPushedFcn', @(btn7,event) PushButtonStop(btn7),...
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
    'CallBack', {@PushButton5, warningpress,s},...
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
    0.957 0.348 0;
    ])

function PushButton1(~,~)
global needspeed
global motorspeed
needspeed=2;
motorspeed= 0;
end

% start
function PushButton2(~,~)
global needspeed
global motorspeed
needspeed=1;
motorspeed= needspeed*10*2*3.14*0.05*100/60;
end

% set speed
function PushButton3(~,~, sliderdata,~,~)
global needspeed
global motorspeed
needspeed=sliderdata.Value.*255;
motorspeed= sliderdata.Value.*10*2*3.14*0.05*100/60;
end


function PushButton4(~,~,~)
global warningpress
warningpress=1;
end

function PushButton5(~,~,~,~)
global warningpress
global s
global motorspeed
global needspeed
warningpress=0;
write(s,1, "string");
needspeed=1;
motorspeed= needspeed*10*2*3.14*0.05*100/60;
end

function PushButtonFile(~, filename)
global usertabl
global f2
myprogress1
delete(filename)
writecell(usertabl,filename, 'WriteMode','overwritesheet')
xlswritefig(f2,filename,'Sheet1','G2')
disp('я сохранил')
end

function PushButtonStop(~, ~)
global go
global s
write(s, 2, "string");
go = 0;
disp('остановка')
end