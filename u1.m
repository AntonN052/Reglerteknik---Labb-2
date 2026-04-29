%%PLOTA GRAFER


function u1(frequency_nr)
w_list = [0.2, 0.39, 0.75, 1.05,1.45, 2.83, 5.50, 8.0];

vinkelhastighet = w_list(frequency_nr);
u = GetSine(vinkelhastighet); %% sinus-in
[y, t] = OpenControl(u);
    
y_est = EstSine(y, t, vinkelhastighet); %% sinus-ut
plot(t, y_est, '--' ,t, u) %% plota kurvorna i samma graf. '--' är för att strecka vår sinus-ut.
    
    
    
belopp = max(y_est) / (max(u)); %%beräkna belopp
[~, index_yest] = max(y_est); %%beräkna fasförskjutning, symbolen '~' används för att markera att vi inte använder värdet som annars hade sparats i variabeln.
[~, index_u] = max(u);
delta_t = t(index_u)-t(index_yest);
fasforskjutning = vinkelhastighet * delta_t;
        
disp(belopp); %% skriv ut belopp och fasförskjutning så att vi slipper beräkna det själva.
disp(fasforskjutning);


end




