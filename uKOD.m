%% PLOTTA GRAFER TILL DE OLIKA VINKELFREKVENSERNA
w_c = 1.45;

w_list = [0.2, 0.39, 0.75, 1.05,w_c, 2.83, 5.50, 8.0];
frekvens_nr = 1; %% ändra för att studera olika frekvenser

vinkelhastighet = w_list(frekvens_nr);
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



%% PLOTTA BODEDIAGRAM OCH NYQUIST
belopp_list = [0.2, 0.39, 0.75, 1.05, 1.45, 2.83, 5.50, 8.0]; %uppmätta belopp
fas_list = [0.2, 0.39, 0.75, 1.05, 1.45, 2.83, 5.50, 8.0];    %uppmätta fasförskjutningar

z_list = belopp_list .* exp(1i * fas_list);
G = frd(z_list, w_list);

figure; margin(G);
figure; nyquist(G); 
[belopp_wc, fas_wc] = bode(G, w_c);



%% BERÄKNA OCH TESTA LEADFILTER
phi_m = 53;
phi_max = phi_m - (fas_wc - (-180)) + 6;


%beta = 0; % bestäm värde på beta genom att läsa av i tabell.
beta = (1 - sin(phi_max * pi/180)) / (1 + sin(phi_max * pi/180));
tauD = 1 / (w_c * sqrt(beta));
K = sqrt(beta) / belopp_wc;
F_lead = K * tf([tauD 1], [beta*tauD 1]);

r = GetStep(1);
[y, t] = FeedbackControl(F_lead, r);
plot(t, [r(:), y(:)]);
legend('Referens', 'Position');
xlabel('Tid [s]'); ylabel('Vinkel [rad]');



%% LÄGG TILL LAGFILTER OCH TESTA MED LASTSTÖRNING
gamma = 0;
tauI = 6.9;
F_lag = tf([tauI 1], [tauI gamma]);

F = F_lead * F_lag;

r = GetStep(-0.2);
[y, t] = FeedbackControl(F, r);
plot(t, [r(:), y(:)]);



%% PLOTTA KRETSFÖRSTÄRKNING OCH ÅTERKOPPLAT SYSTEM
Go = F * G;
figure; margin(Go); % Bode för kretsförstärkningen
figure; nyquist(Go);  % Nyquist
Gc = feedback(Go, 1);
figure; bode(Gc); % Bode för återkopplade systemet
bandwidth(Gc)



%% DENNA DEL ÄR TILL FÖR ATT EXPERIMENTERA UNDER LABBEN

disp(fas_wc)
%%
