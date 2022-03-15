clear;clc;
global motorspeed
motorspeed=0;

% Create figure window and components
fig = uifigure('Name','RESULT','Position',[100 100 500 300]);

% Create labels
lbslave = uilabel(fig,...
    'Position',[100 50 50 15],...
    'Text','slave');

lbmaster = uilabel(fig,...
    'Position',[300 50 50 15],...
    'Text','master');

lbmaster_value = uilabel(fig,...
    'Position',[300 40 50 15],...
    'Text','0');

% Create knob
kb_slave = uiknob(fig,...
    'Position',[100 100 60 60]);

kb_master = uiknob(fig,...
    'Position',[300 100 60 60],...
    'ValueChangedFcn', @(kb,event) knobTurned_master(kb,lbmaster_value,kb_slave));

while(true)
    
end

function knobTurned_master(kb,lbmaster_value,kb_slave)
global motorspeed
motorspeed = kb.Value;
lbmaster_value.Text = num2str(motorspeed);
kb_slave.Value=motorspeed;
end


