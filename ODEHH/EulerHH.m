function [V,to] = EulerHH(V0,C,I,gK_bar,gNa_bar,gL_bar,E_K,E_Na,E_L,dt,t,q)
% solves Hodgkin huxley equations using Euler's method

V = V0;
V_save = zeros(1,t);

%% iteration
for i = 1:t
  V_save(i) = V;
  V         = updateV(V,C,I(i),gK_bar,gNa_bar,gL_bar,E_K,E_Na,E_L,dt,q);
  [a,b]     = alphabeta(V);
  q         = updateq(q,a,b,dt);
end

%% set outputs
V    = V_save;
to   = 1:t;
to   = to*dt; %sets time to ms