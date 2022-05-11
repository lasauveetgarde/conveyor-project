run('init_gui')
write(s, 1, "string");
pause(2)
write(s, 1, "string");

while (go)
    pie(ax1,all_color)
    title('Color pie chart')
    data = read(s,28,"string");
    datatabl(i,:)=double(split(data))';
    kb.Value=motorspeed;
    value_speed.Text=num2str(motorspeed);
    
    if warningpress == 1
        write(s, needspeed, "string");
    else
        stopdistance(i) = datatabl(i,7);
        lenghttabl(i,1) = datatabl(i,3);
        %длина предмета
        if (lenghttabl(i,1) ~=0)
            if motorspeed>0
                cnt=cnt+1;
                continue_measurment = 1;
            end
        elseif lenghttabl(i,1) ==0 && continue_measurment == 1 && cnt>3
            txa1.Value=' ';
            txa2.Value=' ';
            txa3.Value=' ';
            lmp.Color = '#000000';
            txa5.Value  = ('');
            lmp3.Color = '#000000';
            txa4.Value  = ('');
            lmp2.Color = '#000000';
            txa6.Value  = ('');
            lmp4.Color = '#000000';
            z = z + 1;
            end_measurment1 = 1;
            continue_measurment = 0;
            averagelen = sum(lenghttabl ((i - cnt): length(lenghttabl))) / cnt;
            cathetus= averagelen.*0.42./0.906307;
            Objectlenght= (cnt.*motorspeed/2-2.*cathetus)/8;
            if Objectlenght<0
                Objectlenght=0;
            end
            txa3.Value=num2str(Objectlenght);
            usertabl {z,1}=datestr(now,'HH:MM:SS');
            usertabl{z,2}=Objectlenght;
            if ((Objectlenght<LL(1,1)) || (Objectlenght>LL(2,1)))
                txa6.Value  = ('Объект не той длины ');
                lmp4.Color = '#92000a';
            else
                txa6.Value  = ('Объект той длины ');
                lmp4.Color = '#228b22';
            end
            cnt =0;
            fprintf('Покинул зону 1 в %s объект номер %d\n' , datestr(now,'HH:MM:SS'), z);
            write(s, 5, "string");
        end
        
        weighttabl(j) = datatabl(i,1)-115;
        if end_measurment2 ==0
            if i>6
                viborka = stopdistance((i-5):(i-1));
                if (mode(viborka)<=29) == (viborka>28)
                    start_measurment = 1;
                    write(s, 2, "string");
                    motorspeed=0;
                end
                if ((start_measurment == 1)&&(j<=10))
                    rgbtabl(j, 1) = (datatabl(i,4)-100)./256; %%перевод в диапазон значений 0-1
                    rgbtabl(j, 2)= (datatabl(i,5)-100)./256;
                    rgbtabl(j, 3)= (datatabl(i,6)-100)./256;
                    hsvtabl(j,:)= rgb2hsv(rgbtabl(j, :)); %%перевод из RGB в HSV
                    [colour]=what_color(hsvtabl,j);
                    colorval(j) = colour;
                    j=j+1;
                    
                elseif (start_measurment == 1 && end_measurment2 == 0)
                    end_measurment2 = 1;
                    motorspeed=5.2333;
                    
                    answer = sum(weighttabl)/10;
                    weightanswer=sprintf(num2str(sum(weighttabl)/10));
                    txa2.Value=weightanswer;
                    truecolor = mode(colorval);
                    [txa1.Value,lmp.Color]=true_color(truecolor);
                    
                    usertabl{m,4}=answer;
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
                    fprintf('Покинул зону 2 в %s объект номер %d\n' , datestr(now,'HH:MM:SS'), m);
                end
            end
        end
        if end_measurment2
            
            % все верно, все сервы в 0
            if (usertabl{m,4}>=WW(1,1))&&(usertabl{m,4}<=WW(2,1))&& (~isempty(colourfind))...
                    && (usertabl{m,2}>=LL(1,1))&&(usertabl{m,2}<=LL(2,1))
                write(s, 5, "string");
                usertabl {m,5}='Все параметры верны';
                
                %не тот вес, первая серва в положение 45
            elseif ((usertabl{m,4}<WW(1,1))||(usertabl{m,4}>WW(2,1)))&& (~isempty(colourfind))...
                    && (usertabl{m,2}>=LL(1,1))&&(usertabl{m,2}<=LL(2,1))
                write(s, 3, "string");
                usertabl {m,5}='Не тот вес предмета';
                
                %не тот цвет, вторая серва в положение 120
            elseif (usertabl{m,4}>=WW(1,1))&&(usertabl{m,4}<=WW(2,1))&& (isempty(colourfind))...
                    && (usertabl{m,2}>=LL(1,1))&&(usertabl{m,2}<=LL(2,1))
                write(s, 4, "string");
                usertabl {m,5}='Не тот цает предмета';
                
                % длина не та, первая серва в 120
            elseif (usertabl{m,4}>=WW(1,1))&&(usertabl{m,4}<=WW(2,1))&& (~isempty(colourfind))...
                    && ((usertabl{m,2}<LL(1,1))||(usertabl{m,2}>LL(2,1)))
                write(s, 6, "string");
                usertabl {m,5}='Не та длина предмета';
            else
                % вторая серва в положение 45
                write(s, 7, "string");
                disp('Не могу принять решение');
                usertabl {m,5}='Несколько параметров не совпадает';
            end
            start_measurment = 0;
            Objectlenght =0;
            j=1;
            m=m+1;
            end_measurment2 = 0;
        end
    end
    i = i + 1;
end
close_windows(fig);

function [Txcolor] = what_color (tabl,i)
if ((tabl(i, 1)>0) && (tabl(i, 1)<=0.035))
    Txcolor=1;
elseif ((tabl(i, 1)>0.1) && (tabl(i, 1)<=0.186))
    Txcolor=2;
elseif ((tabl(i, 1)>0.186) && (tabl(i, 1)<=0.419))
    Txcolor=5;
elseif ((tabl(i, 1)>0.419) && (tabl(i, 1)<=0.538))
    Txcolor=3;
elseif ((tabl(i, 1)>0.538) && (tabl(i, 1)<=0.7))
    Txcolor=4;
elseif ((tabl(i, 1)>0.7) && (tabl(i, 1)<=0.945))
    Txcolor=6;
elseif ((tabl(i, 1)>0.035) && (tabl(i, 1)<=0.1))
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
    Value='orange color';
    lmpColor = '#ff8700';
    all_color(7)= all_color(7) + 1;
end
end

function close_windows(figure)
disp('вышел из вайла');
close all
close(figure)
end


