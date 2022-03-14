clc
close all
clear all

global s
global needspeed
global warningpress
global motorspeed

delete(instrfind)
s = serialport('COM4', 9600);

% speed = inputdlg({'Input conveyor speed'},'Ввод данных', [1 50]);
% V = str2num(cell2mat(speed));
V = 3;

% colourlist = {'Red','Yellow','Light blue','Blue','Green','Purple','Pink'};
% [indx,tf] = listdlg('ListString',colourlist);
indx = [1, 2, 5, 6, 7];

% ab = inputdlg({'Input min weight','Input max weight'},'Ввод данных', [1 50]);
% WW = str2double(ab);
WW = [0; 100];

k=1; total=0; colour=0; coun=1; sumweight=0; start_measurment = 0; cnt=0;...
    measurement_end2 = 0; needspeed=1; j=1; m=1; motorspeed=5.23;


datatabl=zeros(8); %%все данные с USB-порта
rgbtabl = zeros(3); %%массив для записи значений цвета в RGB в диапазоне 0-1
hsvtabl = zeros(3); %%массив для записи значений цвета в HSV в диапазоне 0-1
lenghttabl=zeros(2); %%массив для записи значений длины предмета
weighttabl=zeros(1); %%массив для записи значений массы предмета
usertabl = zeros(5);
stopdistance = zeros(1);

data="";
fig = uifigure('Name','RESULT');
fig.Position = [50   450   400   250];
ppanel1 = uipanel(fig,'Position',[50 50 140 140]);
lmp = uilamp(ppanel1,'Position',[20 20 100 100]);

ppanel2 = uipanel(fig,'Position',[100 200 90 30]);
txa1 = uitextarea(ppanel2,'Position',[0 0 90 30],'HorizontalAlignment', 'center');

ppanel3 = uipanel(fig,'Position',[200 200 90 30]);
txa2 = uitextarea(ppanel3,'Position',[0 0 90 30],'HorizontalAlignment', 'center');

ppanel4 = uipanel(fig,'Position',[300 200 90 30]);
txa3 = uitextarea(ppanel4,'Position',[0 0 90 30],'HorizontalAlignment', 'center');

ppanel5 = uipanel(fig,'Position',[220 20 170 170]);
kb = uiknob(ppanel5,'continuous','Position',[35 20 100 100],...
    'ValueChangedFcn', @(kb,event) knobTurned(kb,motorspeed));
kb.Limits =[0 6];

f=figure('Name','Control Speed', 'NumberTitle', 'Off');
f.Position = [550   400   550   350];
sliderdata=uicontrol(f,'BackgroundColor','#0072BD','style','Slider','Min',0,'Max',1,...
    'Value',1,'units','normalized');
sliderdata.Position = [0.1 0.1 0.05 0.8];

pan1 = uipanel(f,'Position',[0.17 0.2 0.2 0.1]);
btn1=uicontrol(pan1,'BackgroundColor',	'red', 'style','pushbutton',...
    'String','Stop','CallBack',@PushButton1, 'Position', [1.6 1.2 108 38.79 ]);

pan2 = uipanel(f,'Position',[0.17 0.3 0.2 0.1]);
btn2=uicontrol(pan2,'BackgroundColor',	'green','style','pushbutton',...
    'String','Max speed','CallBack', @PushButton2, 'Position', [1.6 1.2 108 38.79 ]);

pan3 = uipanel(f,'Position',[0.17 0.4 0.2 0.1]);
btn3=uicontrol(pan3,'style','pushbutton', 'String','Set speed',...
    'CallBack', {@PushButton3, sliderdata, needspeed, motorspeed},...
    'Position', [1.6 1.2 108 38.79 ]);

pan4 = uipanel(f,'Position',[0.18 0.6 0.3 0.1]);
btn4=uicontrol(pan4,'style','pushbutton', 'String','Ручное управление',...
    'CallBack', {@PushButton4, warningpress}, ...
    'Position', [1.6 1.7 164 38.79 ]);

pan5 = uipanel(f,'Position',[0.53 0.6 0.3 0.1]);
bt5=uicontrol(pan5,'style','pushbutton', 'String','Автомат. управление',...
    'CallBack', {@PushButton5, warningpress},...
    'Position', [1.6 1.7 164 38.79 ]);

while (true)
    f=gcf;
    
    for i = 1:10000

        write(s, 1, "string");
        data = read(s,28,"string");
        datatabl(i,:)=double(split(data))';
        if warningpress == 1
            write(s, needspeed, "string");
        else
            stopdistance(i) = datatabl(i,7);
            %масса предмета
            if ((stopdistance(i)>=15)&&(stopdistance(i)<=20)&& (start_measurment==0))
                start_measurment = 1;
                m=m+1;
            end
            if ((start_measurment == 1)&&(j<=3))
                write(s, 2, "string");
                motorspeed = 0;
                weighttabl(j) = datatabl(i,1)-100;
                j=j+1;           
            else       
                answer = sum(weighttabl)/3;
                weightanswer=sprintf(num2str(answer));
                txa2.Value=weightanswer;
                usertabl(m,1)=answer;
                %%отображение цвета и его вывод  
                if ((answer<WW(1,1)) || (answer>WW(2,1)) && (start_measurment == 1))
                    write(s, 3, "string");
                    wrongcolour = warndlg('Объект не того веса ','Предупреждение ');
                    uiwait(wrongcolour,1)
                    close (wrongcolour)
%                     weighttabl(j)=0;
                end   
                j=1;
                start_measurment=0;
            end
            rgbtabl(i, 1) = (datatabl(i,4)-100)./256; %%перевод в диапазон значений 0-1
            rgbtabl(i, 2)= (datatabl(i,5)-100)./256;
            rgbtabl(i, 3)= (datatabl(i,6)-100)./256;
            hsvtabl(i,:)= rgb2hsv(rgbtabl(i, :)); %%перевод из RGB в HSV
            
            [txa1.Value,colour,lmp.Color]=what_color(hsvtabl,i);
            
            lenghttabl(i,1) = datatabl(i,3);
            if (lenghttabl(i,1) ~=0)
                cnt=cnt+1;
                measurement_end2 = 1;
            else
                if measurement_end2 == 1
                    averagelen = sum(lenghttabl ((i - cnt): length(lenghttabl))) / cnt;
                    cathetus= averagelen.*0.42./0.906307;
                    Objectlenght= cnt.*motorspeed-2.*cathetus;
                    txa3.Value=num2str(Objectlenght);
                end
                measurement_end2 = 0;
                cnt =0;
                Objectlenght =0;
            end
            
            %сообщение об ошибке, если цвет не соответсвует
            colourfind=find(indx==colour);
            if isempty(colourfind)
                write(s, 4, "string")
                %                     %                     wrongcolour = warndlg('Объект не того цвета ','Предупреждение ');
                %                     %                     uiwait(wrongcolour,1)
                %                     %                     close (wrongcolour)
            end
            
        end
    end
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

function knobTurned(kb, ~)
global motorspeed
kb.Value=motorspeed;
end

function PushButton4(src,~,~)
global warningpress
warningpress=1;
end

function PushButton5(src,~,~)
global warningpress
warningpress=0;
end

function [Value,Txcolor,lmpColor] = what_color (tabl,i)
if ((tabl(i, 1)>0) && (tabl(i, 1)<0.054))
    Value='red color';
    Txcolor=1;
    lmpColor = '#92000a';
end
if ((tabl(i, 1)>0.054) && (tabl(i, 1)<0.1265))
    Value='yellow color';
    Txcolor=2;
    lmpColor = '#ffd700';
end
if ((tabl(i, 1)>0.1265) && (tabl(i, 1)<0.3645))
    Value='green color';
    Txcolor=5;
    lmpColor = '#228b22';
end
if ((tabl(i, 1)>0.3645) && (tabl(i, 1)<0.486))
    Value='light blue color';
    Txcolor=3;
    lmpColor = '#6495ed';
end
if ((tabl(i, 1)>0.486) && (tabl(i, 1)<0.675))
    Value='blue color';
    Txcolor=4;
    lmpColor = '#310062';
end
if ((tabl(i, 1)>0.675) && (tabl(i, 1)<0.7425))
    Value='purple color';
    Txcolor=6;
    lmpColor = '#7E2F8E';
end
if ((tabl(i, 1)>0.7425) && (tabl(i, 1)<0.945))
    Value='pink color';
    Txcolor=7;
    lmpColor = '#ffc0cb';
end
end


