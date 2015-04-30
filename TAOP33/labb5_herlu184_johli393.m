%TAOP33 Herman lundkvist (herlu184), Johan Lindberg (johli393)

% läs in indatafil
load(input('Ange datafil: ','s'));

tic % ta tid

x = zeros(size(c));  % x-matris med flöden mellan fabrik och kund.
y = zeros(size(f));  % y-vektor med ettor för fabriker som ska byggas

disp(sprintf('Antal fabriker: %d, antal kunder: %d',m,n));
disp(sprintf('Total kapacitet: %d, total efterfrågan: %d',sum(s),sum(d)));

ss=s;      % återstående fabrikskapacitet, minska då transporter sker
dd=d;      % återstående efterfrågan, minska då transporter sker
cc=c;      % temp c, kan ändras
ff=f;      % temp f, kan ändras
           % ss,dd,cc,ff kan ändras, s,d,f,c bör ej ändras

% sätt värdet på e
e=100;
  
%loopa till alla kunders efterfrågan är uppfylld
% välj fabrik, välj kund, skicka, på billigaste sätt

% uppdatera x, y, ss och dd, samt ev ff och cc

M = 10^20;

%Vikta temporär kostnad med fabrikskostnader
for i=1:length(s)
        cc(i,:) = e*ff(i)*ff(i)*ff(i)*cc(i,:);
end

while  sum(dd) > 0 
    best_factory= 1;
    best_customer = 1;
    cost_transport = M;
    
    %Loopa igenom för att hitta billigste viktade transportkostnaden
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
    
    %Skicka så mycket som möljigt på denna väg
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