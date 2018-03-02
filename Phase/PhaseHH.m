%% help
%script to make phase diagrams for Hodgkin-Huxley model using simplified
%Rinzel's model. Creates nullclines and example conditions

%% set variables
gK_bar = 36;  gNa_bar = 120; gL_bar = 0.3;   %max conductances in mS/cm^2
E_K    = -12; E_Na    = 115; E_L    = 10.6;  %Nernst equilibrium constants in mV note: hodgkin-huxley shifted V_rest to zeros
g      = [gK_bar,gNa_bar,gL_bar];
E      = [E_K,E_Na,E_L];
[a,b]  = alphabeta(0);    %alpha and beta at resting potentials
q0     = a./(b + a); 

%% run ODE45 for various V0 and w0
V0        = -2:0.5:9;
w0        = 0.3539:.01:.5039;
n         = length(V0)*length(w0);
out(n).t  = 0;
out(n).Vw = 0;
iter      = 0;

for wi = 1:length(w0)
    for Vi = 1:length(V0)
        iter = iter+1;
        [out(iter).t,out(iter).Vw] = ODE45Phase(V0(Vi),w0(wi),g,E,q0);
    end
end

%% figure 1 Phase diagram
figure(1)
hold on
for iter = 1:n
    plot(out(iter).Vw(:,1),out(iter).Vw(:,2))
end
hold off
xlabel('Membrane Potential, mV')
ylabel('Recovery Variable, w')

%% end