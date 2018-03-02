close all; clearvars;
%% help
%solve hodgkin huxley equations using ODE45.

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

%% solve using ODE45
Istr = 70;
Ilen = [0.02,0.13,10-0.15];
[Vode,tode] = ODE45HH(Istr,Ilen,V0,q,g,E,C);

%% solve using Euler
out(3).Ve = 0;
out(3).te = 0;
for iter = 1:3
    iterm = 10^(iter+1);
    t  = 10*iterm; %time in ms/100
    dt = 1/iterm; %step size
    I  = zeros(1,t);
    I(0.02*iterm:0.15*iterm) = 70;
    [out(iter).Ve,out(iter).te] = EulerHH(V0,C,I,gK_bar,gNa_bar,gL_bar,E_K,E_Na,E_L,dt,t,q);
end

%% figure 1: ODE45 vs Euler method action potential
figure(1)
plot(tode,Vode(:,1))
hold on
colors = {'r--','g--','k--'};
for iter = 1:3
    plot(out(iter).te,out(iter).Ve,colors{iter})
end
hold off
title('Compare Euler''s method to ODE45')
xlabel('time (ms)')
ylabel('membrane potential (mV)')
legend('ODE45','Euler''s method, dt = 0.01','Euler''s method, dt = 0.001','Euler''s method, dt = 0.0001')

%% solve using ODE45
Istr = 30;
Ilen = [0.02,0.13,10-0.15];
[Vode,tode] = ODE45HH(Istr,Ilen,V0,q,g,E,C);

%% solve using Euler
clear out
out(3).Ve = 0;
out(3).te = 0;
for iter = 1:3
    iterm = 10^(iter+1);
    t  = 10*iterm; %time in ms/100
    dt = 1/iterm; %step size
    I  = zeros(1,t);
    I(0.02*iterm:0.15*iterm) = 30;
    [out(iter).Ve,out(iter).te] = EulerHH(V0,C,I,gK_bar,gNa_bar,gL_bar,E_K,E_Na,E_L,dt,t,q);
end

%% figure 2: ODE45 vs Euler method no action potential
figure(2)
plot(tode,Vode(:,1))
hold on
colors = {'r--','g--','k--'};
for iter = 1:3
    plot(out(iter).te,out(iter).Ve,colors{iter})
end
hold off
title('Compare Euler''s method to ODE45')
xlabel('time (ms)')
ylabel('membrane potential (mV)')
legend('ODE45','Euler''s method, dt = 0.01','Euler''s method, dt = 0.001','Euler''s method, dt = 0.0001')

%% Finding threshold
clear out
out(19).Vode = 0;
out(19).tode = 0;
count = 0;
for i = 49:0.1:51
    count = count + 1;
    Istr = i;
    Ilen = [0.02,0.13,10-0.15];
    [out(count).Vode,out(count).tode] = ODE45HH(Istr,Ilen,V0,q,g,E,C);
end

%% figure 3: finding threshold
figure(3)
thresh = max(out(12).Vode(:,1));
h = zeros(1,19);
for i = 1:19
    h(i) = plot(out(i).tode,out(i).Vode(:,1));
    hold on
end
ht = plot([0 out(1).tode(end)],[thresh thresh],'k--');
ymark =get(gca,'YTick');
ymark = [ymark,thresh];
ymark = sort(ymark);
set(gca,'YTick',ymark)
title('Finding the threshold')
xlabel('time (ms)')
ylabel('membrane potential (mV)')
legend(ht,'V_{thresh}')

%% Various inputs currents
clear out
out(8).Vode = 0; out(8).tode = 0; out(8).Istr = 0; out(8).Ilen = 0; %preallocate out struct

%threshhold
out(1).Istr = 70;
out(1).Ilen = [0.02,0.13,10-0.15];
[out(1).Vode,out(1).tode] = ODE45HH(out(1).Istr,out(1).Ilen,V0,q,g,E,C);

%subthreshold
out(2).Istr = 35;
out(2).Ilen = [0.02,0.13,10-0.15];
[out(2).Vode,out(2).tode] = ODE45HH(out(2).Istr,out(2).Ilen,V0,q,g,E,C);

%summation
out(3).Istr = [30,30];
out(3).Ilen = [0.02,0.13,0.5,0.15,10-0.75];
[out(3).Vode,out(3).tode] = ODE45HH(out(3).Istr,out(3).Ilen,V0,q,g,E,C);

%Constant I
out(4).Istr = 70;
out(4).Ilen = [0.02,50-.02,50-.02];
[out(4).Vode,out(4).tode] = ODE45HH(out(4).Istr,out(4).Ilen,V0,q,g,E,C);

%vary time between inputs
Ilenhold = {[0.02,0.13,13.5,0.15,10-0.71]
            [0.02,0.13,13.75,0.15,10-0.76]
            [0.02,0.13,14,0.15,10-0.81]
            [0.02,0.13,14.25,0.15,10-0.87]};
for i = 5:8
    out(i).Istr = [70,70];
    out(i).Ilen = Ilenhold{i-4};
    [out(i).Vode,out(i).tode] = ODE45HH(out(i).Istr,out(i).Ilen,V0,q,g,E,C);
end

%% figure 4: action potential
figure(4)
[h1,h2] = plotcurrHH(out(1).Vode,out(1).tode,E,g,out(1).Ilen,out(1).Istr);
title(h1,'Action potential')
set(h1,'ylim',[-20,130])
set(h2,'ylim',[0,100])

%% figure 5: subthreshold
figure(5)
[h1,h2] = plotcurrHH(out(2).Vode,out(2).tode,E,g,out(2).Ilen,out(2).Istr);
title(h1,'subthreshold input')
set(h1,'ylim',[-10,30])
set(h2,'ylim',[0,100])

%% figure 6: summation
figure(6)
[h1,h2] = plotcurrHH(out(3).Vode,out(3).tode,E,g,out(3).Ilen,out(3).Istr);
title(h1,'summation of subthreshold inputs')
set(h1,'ylim',[-20,130])
set(h2,'ylim',[0,100])

%% figure 7 constant I
figure(7)
[h1,h2] = plotcurrHH(out(4).Vode,out(4).tode,E,g,out(4).Ilen,out(4).Istr);
title(h1,'Constant I')
set(h1,'ylim',[-20,130])
set(h2,'ylim',[0,100])

%% figure 8-11
for i = 5:8
    figure(i+3)
    [h1,h2] = plotcurrHH(out(i).Vode,out(i).tode,E,g,out(i).Ilen,out(i).Istr);
    title(h1,['Varied Inputs',num2str(i-4)])
    set(h1,'ylim',[-20,130])
    set(h2,'ylim',[0,100])
end

%% figure 12: plot m,n,h, ion current, and conductances
figure(12)
[h1,h2,h3,h4] = plotHHstandard(out(1).Vode,out(1).tode,E,g);
set(h1,'ylim',[-20,125])
linkaxes([h1,h2,h3,h4],'x')

%% figure 13: time constants
%V        = out(1).Vode(:,1);
V        = -40:100;
alpha    = zeros(3,length(V));
beta     = alpha;

%find alpha and beta from V
alpha(1,:) = (0.01.*(10-V)./(exp((10-V)./10)-1));
alpha(2,:) = (0.1.*(25-V)./(exp((25-V)./10)-1));
alpha(3,:) = (0.07.*exp(-V./20));
beta(1,:)  = (0.125.*exp(-V./80));
beta(2,:)  = (0.4.*exp(-V/18));
beta(3,:)  = 1./(exp((30-V)./10)+1);

%solve for time constants tau
tau = 1./(alpha + beta);

figure(13)
plot(V,tau)
title('Time Constants, \tau')
xlabel('mV')
legend('n','m','h')
set(gca,'xlim',[-40 100])
