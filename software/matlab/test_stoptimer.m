% fig = uifigure('Name','Result window');
% fig.Position = [10   400   500   320];
% pan = uipanel(fig,'Position',[160 50 100 30]);
% global t
% global usertabl
% usertabl = cell(1);
% usertabl(:,:) = {0};
% usertabl {1,1}='TIME';
% btn=uibutton(pan,'push','Text', 'test',...
%     'ButtonPushedFcn', @(btn,event,usertabl) PushButtonStop(btn),...
%     'Position', [0 0 100 30 ]);
%
%
% function PushButtonStop(~, ~)
% global usertabl
% global t
% global d1
% usertabl {2,1}=datestr(now,'HH:MM:SS');
% t = datetime(usertabl{2,1},'InputFormat','HH:mm:ss');
% d1 = '00:00:05';
% if datetime('now')-t==d1
%     disp('hi')
% end
% end

fig = uifigure('Name','Result window');
fig.Position = [10   400   500   320];
pan = uipanel(fig,'Position',[160 50 100 30]);
btn=uibutton(pan,'push','Text', 'test',...
    'ButtonPushedFcn', @(btn,event,usertabl) PushButtonStop(btn),...
    'Position', [0 0 100 30 ]);
pause(1)

usertabl = cell(1);
usertabl(:,:) = {0};
usertabl{1,1}='TIME';
usertabl{2,1}=datestr(now,'HH:MM:SS');
global t
t = datetime('now') + hours(2);


while(1)
    current_time = datetime('now');
    disp(current_time - t);
    pause(0.5)
    if (current_time - t) >= seconds(2)
        disp('meow')
        break
    end
end

function PushButtonStop(~, ~)
global usertabl
global t
usertabl{2,1}=datestr(now,'HH:MM:SS');
t = datetime(usertabl{2,1},'InputFormat','HH:mm:ss');
end


