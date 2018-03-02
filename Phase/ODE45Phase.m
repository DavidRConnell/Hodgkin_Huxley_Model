function [t,Vw] = ODE45Phase(V0,w0,g,E,q0)
%Uses ODE45 to solve the FitzHugh-Nugumo system of ODEs. Output Vw contains
%Voltage in the first column and the recovery variable in the second
%column. V0 and w0 are the intial conditions for V and w, a,b, and c are
%adjustable constants for the model, and I is the input current. 

%% ode45
tspan  = 0:100;   %needs enough time to reach equilibrium
V0     = [V0,w0]; %combine inputs into single variable
[t,Vw] = ode45(@dsolvePhase,tspan,V0,[],g,E,q0);

%% end