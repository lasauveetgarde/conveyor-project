function xlswritefig(hFig,filename,sheetname,xlcell)

if nargin==0 || isempty(hFig)
    hFig = gcf;
end

if nargin<2 || isempty(filename)
    filename ='';
    dontsave = true;
else
    dontsave = false;
    filename = fullfilename(filename);
end

if nargin < 3 || isempty(sheetname)
    sheetname = 'Sheet1';
end;

if nargin<4
    xlcell = 'A1';
end

if ~verLessThan('matlab','9.8')
    copygraphics(hFig)
else
    r = get(hFig,'Renderer');
    set(hFig,'Renderer','Painters')
    drawnow
    hgexport(hFig,'-clipboard')
    set(hFig,'Renderer',r)
end

Excel = actxserver('Excel.Application');

if exist(filename,'file')==0
    op = invoke(Excel.Workbooks,'Add');
    new=1;
else
    op = invoke(Excel.Workbooks, 'open', filename);
    new=0;
end
try
    Sheets = Excel.ActiveWorkBook.Sheets;
    target_sheet = get(Sheets, 'Item', sheetname);
catch 
    target_sheet = Excel.ActiveWorkBook.Worksheets.Add();
    target_sheet.Name = sheetname;

end;

invoke(target_sheet, 'Activate');
Activesheet = Excel.Activesheet;

Paste(Activesheet,get(Activesheet,'Range',xlcell,xlcell))

if new && ~dontsave
    invoke(op, 'SaveAs', filename);
elseif ~new
    invoke(op, 'Save');
else  
    set(Excel, 'Visible', 1);
    return 
end
invoke(Excel, 'Quit');
delete(Excel)
end


function filename = fullfilename(filename)
[filepath, filename, fileext] = fileparts(filename);
if isempty(filepath)
    filepath = pwd;
end
if isempty(fileext)
    fileext = '.xlsx';
end
filename = fullfile(filepath, [filename fileext]);
end
