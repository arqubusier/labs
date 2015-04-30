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
e=1;
  
%loopa till alla kunders efterfrågan är uppfylld
% välj fabrik, välj kund, skicka, på billigaste sätt

% uppdatera x, y, ss och dd, samt ev ff och cc

M = 10000000;

factory_costs = sum(cc,2);
while  sum(dd) > 0 
    best_factory = 1;
    cost_factory = M;
    
    %choose the factory with the lowest cost
    for i=1:length(factory_costs)
        if factory_costs(i) < cost_factory
            cost_factory = factory_costs(i);
            best_factory = i;
        end
    end
    
    factory_costs(best_factory) = M;
    
    while ss(best_factory) > 0 && sum(dd) > 0
        best_customer = 1;
        cost_customer = M;

        %Choose the customer with the lowest cost
        for j=1:length(d)
            if cc(best_factory,j) < cost_customer
                cost_customer = cc(best_factory,j);
                best_customer = j;
            end
        end

        cc(best_factory, best_customer) = M;


        if ss(best_factory) >= dd(best_customer)
            ss(best_factory) = ss(best_factory) - dd(best_customer);
            y(best_factory) = 1;
            x(best_factory, best_customer) = dd(best_customer);
            dd(best_customer) = 0;
        else
            dd(best_customer) = dd(best_customer) - ss(best_factory);
            y(best_factory) = 1;
            x(best_factory, best_customer) = ss(best_factory);
            ss(best_factory) = 0;
        end
    end
end

disp(sprintf('Antal fabriker byggda: %d',sum(y)));
cost_customer=sum(sum(c.*x)) + e*sum(f.*y);
fprintf('Totalkostnad: %.2f\n', cost_customer);
str0=sprintf('%d ',y);
disp(sprintf('Byggda fabriker: %s',str0));

toc % ta tid