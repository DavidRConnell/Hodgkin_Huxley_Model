%% help 
%Compares the time for ODE45 vs Euler's method

%% constants
% Neuron constants (from Dynamical Systems in Neuroscience)
C      = 1;                                  %capacitance in uF
gK_bar = 36;  gNa_bar = 120; gL_bar = 0.3;   %max conductances in mS/cm^2
E_K    = -12; E_Na    = 115; E_L    = 10.6;  %Nernst equilibrium constants in mV note: hodgkin-huxley shifted V_rest to zeros
g      = [gK_bar,gNa_bar,gL_bar];
E      = [E_K,E_Na,E_L];

%% initial conditions
V0      = 0;                %resting membrane potential
I0      = 0;                %input current at t = 0
[a,b]   = alphabeta(V0);    %alpha and beta at resting potentials
q       = a./(b + a);       %(in)activation constants, rows contain n,m, and h respectively
                            % n,m,h assume steady-state at rest to solve for q

%% test 
t = zeros(1,4);

Istr = 70;
Ilen = [0.02,0.13,10-0.15];

tic
for i = 1000
    [V,ti] = ODE45HH(Istr,Ilen,V0,q,g,E,C);
end
t(1) = toc;

for j = 1:3
    iterm = 10^(j+1);
    t0  = 10*iterm; %time in ms/100
    dt = 1/iterm; %step size
    I  = zeros(1,t0);
    I(0.02*iterm:0.15*iterm) = 70;
    
    tic
    for i = 1000
        [V,ti] = EulerHH(V0,C,I,gK_bar,gNa_bar,gL_bar,E_K,E_Na,E_L,dt,t0,q);
    end
    t(j+1) = toc;
end

%% plot results
names = {'ODE45','Euler dt = 0.01','Euler dt = 0.001','Euler dt = 0.0001'};
tdiff = t./t(1);

figure(1) 
bar(t)
title('Comparison of avg time to solve ODE (1000 trials)')
ylabel('time (ms)')
xlabel('method')
set(gca,'xticklabel',names)

fprintf('\nResults: \n')
fprintf('Euler dt = 0.01 took %.2f times as long as ODE45 \n',tdiff(2))
fprintf('Euler dt = 0.001 took %.2f times as long as ODE45 \n',tdiff(3))
fprintf('Euler dt = 0.0001 took %.2f times as long as ODE45 \n\n',tdiff(4))
