usertabl = cell(3);
usertabl(:,:) = {0};
usertabl {1,1}='TIME';
usertabl {1,2}='LENGHT';
usertabl {1,3}='COLOR';
m=2;
n=2;
p=2;

for m=m:1:15
    usertabl{m,1}=m;
end
for n=n:1:4
    usertabl{n,2}=n+10;
    if ((~isempty(usertabl{p,1}))&&(~isempty(usertabl{p,2})))
        disp('good')
    end
end



