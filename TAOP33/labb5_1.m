% l�s in indatafil
load(input('Ange datafil: ','s'));

tic % ta tid

x = zeros(size(c));  % x-matris med fl�den mellan fabrik och kund.
y = zeros(size(f));  % y-vektor med ettor f�r fabriker som ska byggas

disp(sprintf('Antal fabriker: %d, antal kunder: %d',m,n));
disp(sprintf('Total kapacitet: %d, total efterfr�gan: %d',sum(s),sum(d)));

ss=s;      % �terst�ende fabrikskapacitet, minska d� transporter sker
dd=d;      % �terst�ende efterfr�gan, minska d� transporter sker
cc=c;      % temp c, kan �ndras
ff=f;      % temp f, kan �ndras
           % ss,dd,cc,ff kan �ndras, s,d,f,c b�r ej �ndras

% s�tt v�rdet p� e
e=100;
  
%loopa till alla kunders efterfr�gan �r uppfylld
% v�lj fabrik, v�lj kund, skicka, p� billigaste s�tt

% uppdatera x, y, ss och dd, samt ev ff och cc

M = 10^20;

for i=1:length(s)
        cc(i,:) = e*ff(i)*ff(i)*ff(i)*cc(i,:);
end

while  sum(dd) > 0 
    best_factory= 1;
    best_customer = 1;
    cost_transport = M;
    
    for i=1:length(s)
        for j=1:length(d)
            if cc(i,j) < cost_transport
                cost_transport = cc(i,j);
                best_factory = i;
                best_customer = j;
            end
        end
    end
    
    cc(best_factory, best_customer) = M;
    
    if ss(best_factory) >= dd(best_customer)
        y(best_factory) = 1;
        x(best_factory, best_customer) = dd(best_customer);
        ss(best_factory) = ss(best_factory) - dd(best_customer);
        dd(best_customer) = 0;
    else
        y(best_factory) = 1;
        x(best_factory, best_customer) = ss(best_factory);
        dd(best_customer) = dd(best_customer) - ss(best_factory);
        ss(best_factory) = 0;
    end
end

disp(sprintf('Antal fabriker byggda: %d',sum(y)));
cost_customer=sum(sum(c.*x)) + e*sum(f.*y);
fprintf('Totalkostnad: %.2f\n', cost_customer);
str0=sprintf('%d ',y);
disp(sprintf('Byggda fabriker: %s',str0));

toc % ta tid