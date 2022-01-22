clc
clear all
close all

global s
delete(instrfind)
s = serial('COM4', 'BaudRate', 9600);
fopen(s);

% speed = inputdlg({'Input conveyor speed'},'Ввод данных', [1 50]);
% V = str2num(cell2mat(speed));

colourlist = {'Red','Yellow','Light blue','Blue','Green','Purple','Pink'};
[indx,tf] = listdlg('ListString',colourlist);

ab = inputdlg({'Input min weight','Input max weight'},'Ввод данных', [1 50]);
WW = str2double(ab);  

k=1; total=0; colour=0; count=1; sumweight=0; measurement_end = 0;

datatabl=zeros(6); %%все данные с USB-порта
rgbtabl = zeros(3); %%массив для записи значений цвета в RGB в диапазоне 0-1
hsvtabl = zeros(3); %%массив для записи значений цвета в HSV в диапазоне 0-1
lengthtabl=zeros(1); %%массив для записи значений длины предмета
weighttabl=zeros(1); %%массив для записи значений массы предмета

data="";

while (true)
    
    for i = 1:5000
        data = fgets(s);
        result=convertCharsToStrings(data);
        flushinput(s);
        
        datatabl(i,:)=double(split(result))';
        
        %масса предмета
        weighttabl(i) = datatabl(i,1);
        if (weighttabl(i) ~=0)
            count=count+1;
%             sumweight = sumweight+weighttabl(i);
%             resultweight=sumweight/count;
%             disp(resultweight)
            measurement_end = 1;
        else
            
            if measurement_end == 1
                answer = sum(weighttabl ((i - count): length(weighttabl))) / count;
                disp(['Final result: ', num2str(answer)]);
                if ((answer<WW(1,1)) || (answer>WW(2,1)))
                    wrongcolour = warndlg('Объект не того веса ','Предупреждение ');
                    uiwait(wrongcolour,1)
                    close (wrongcolour)
                end
            end
            measurement_end = 0;
            count =0;
            resultweight =0;
            sumweight =0;
            
            rgbtabl(i, 1) = datatabl(i,2)./256; %%перевод в диапазон значений 0-1
            rgbtabl(i, 2)= datatabl(i,3)./256;
            rgbtabl(i, 3)= datatabl(i,4)./256;
            hsvtabl(i,:)= rgb2hsv(rgbtabl(i, :)); %%перевод из RGB в HSV
            
            %%отображение цвета и его вывод
            
            if ((hsvtabl(i, 1)>0) && (hsvtabl(i, 1)<0.054))
                disp('RED color')
                colour=1;
                plot (0, 0, 'o', 'MarkerSize', 200, 'MarkerFaceColor', '#92000a')
                
            end
            if ((hsvtabl(i, 1)>0.054) && (hsvtabl(i, 1)<0.1265))
                disp('YELLOW color')
                colour=2;
                plot (0, 0, 'o', 'MarkerSize', 200, 'MarkerFaceColor', '#ffd700')
                
            end
            if ((hsvtabl(i, 1)>0.1265) && (hsvtabl(i, 1)<0.3645))
                disp('GREEN color')
                colour=5;
                plot (0, 0, 'o', 'MarkerSize', 200, 'MarkerFaceColor', '#228b22')
            end
            if ((hsvtabl(i, 1)>0.3645) && (hsvtabl(i, 1)<0.486))
                disp('LIGHT BLUE color')
                colour=3;
                plot (0, 0, 'o', 'MarkerSize', 200, 'MarkerFaceColor', '#6495ed')
            end
            if ((hsvtabl(i, 1)>0.486) && (hsvtabl(i, 1)<0.675))
                disp('BLUE color')
                colour=4;
                plot (0, 0, 'o', 'MarkerSize', 200, 'MarkerFaceColor', '#310062')
            end
            if ((hsvtabl(i, 1)>0.675) && (hsvtabl(i, 1)<0.7425))
                disp('PURPLE color')
                colour=6;
                plot (0, 0, 'o', 'MarkerSize', 200, 'MarkerFaceColor', 	'#7E2F8E')
            end
            if ((hsvtabl(i, 1)>0.7425) && (hsvtabl(i, 1)<0.945))
                disp('PINK color')
                colour=7;
                plot (0, 0, 'o', 'MarkerSize', 200, 'MarkerFaceColor', '#ffc0cb' )
            end
            
            %%сообщение об ошибке, если цвет не соответсвует
            colourfind=find(indx==colour);
            if isempty(colourfind)
                wrongcolour = warndlg('Объект не того цвета ','Предупреждение ');
                uiwait(wrongcolour,1)
                close (wrongcolour)
            end
            
            %%вычисление длины предмета
            
%             if (datatabl(i,5)==1) %%object length calculation
%                 total=total+1;
%                 i=i+1;
%             else
%                 len=0;
%                 len = total*0.2*V; %%need to enter conveyor speed
%                 lengthtabl(i,1)=double(len)';
%                 disp(len)
%                 total=0;
%             end
        end
        i=i+1;
        pause(0.5)
     end
end
fclose(s);