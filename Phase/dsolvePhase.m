function prime = dsolvePhase(t,x,g,E,q0)
%used with ODE45Phase to solve Rinzel's system of equations. x(1)
%represents V and x(2) represents the recovery variable w.

%% create functions for variables at inf
qinf     = @(a,b) a./(a+b);
an       = @(V) 0.01.*((10-V)./(exp((10-V)./10)-1));
am       = @(V) 0.1.*((25-V)./(exp((25-V)./10)-1));
ah       = @(V) 0.07.*exp(-V./20);
bn       = @(V) 0.125.*exp(-V./80);
bm       = @(V) 4.*exp(-V./18);
bh       = @(V) 1./(exp((30-V)./10)+1);
phi      = 1;

%% setup diff equations
S        = (1-q0(3))/q0(1);
prime    = zeros(2,1);
prime(1) = -(g(1)*(x(2)/S)^4*(x(1)-E(1))+g(2)*(qinf(am(x(1)),bm(x(1)))^3)*(1-x(2))*(x(1)-E(2))+g(3)*(x(1)-E(3)));
prime(2) = phi*(S*(qinf(an(x(1)),bn(x(1)))+S*(1-qinf(ah(x(1)),bh(x(1)))))/(1+S^2) - x(2))/(5*exp(-((x(1)+10)^2)/55^2)+1);

%% end