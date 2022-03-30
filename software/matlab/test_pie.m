a=1;
b= 5;
c=9;
x=[a b c];
filename = '1.xlsx';

usertabl = cell(5);
usertabl(:,:) = {0};
usertabl {1,1}='Time';
usertabl {1,2}='Weight';
usertabl {1,3}='Color';
usertabl {1,4}='Lenght';

f2=figure('Name','Color pie', 'NumberTitle', 'Off','MenuBar', 'none');
f2.Position = [1100   400   350   250];
t = tiledlayout(1,1,'TileSpacing','compact');
ax1 = nexttile;
pie(ax1,x)

recycle on % Send to recycle bin instead of permanently deleting.
delete(filename)
writecell(usertabl,filename, 'WriteMode','overwritesheet')
xlswritefig(f2,filename,'Sheet1','J10')