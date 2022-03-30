function myprogress1
    fig2 = uifigure;
    fig2.Position = [450   400   500   140];
    d = uiprogressdlg(fig2,'Title','Please Wait',...
        'Message','Opening the application');
    pause(.5)
    d.Value = .10; 
    d.Message = 'Save 10%';
    pause(0.3)
    d.Value = .22; 
    d.Message = 'Save 22%';
    pause(0.3)
    d.Value = .47; 
    d.Message = 'Save 47%';
    pause(0.3)
    d.Value = .64; 
    d.Message = 'Save 64%';
    pause(0.3)
    d.Value = .81; 
    d.Message = 'Save 81%';
    pause(0.3)
    d.Value = 1; 
    d.Message = 'Save 100%';
    pause(0.3)
    close(fig2)
end