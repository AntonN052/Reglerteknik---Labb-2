%%PLOTA BODEDIAGRAM

function u12
w_list = [0.2, 0.39, 0.75, 1.05, 1.45, 2.83, 5.50, 8.0];
belopp_list = []; %uppmätta belopp
fas_list = [];    %uppmätta fasförskjutningar




z_list = belopp_list .* exp(1i * fas_list);
G = frd(z_list, w_list);

margin(G); %% plottar ett Bodediagram med skärfrekvens och fasmarginal utmarkerade
nyquist(G);

end

