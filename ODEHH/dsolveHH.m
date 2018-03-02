function prime = dsolveHH(t,x,g,E,C,I)
% used for ODE45 in ODEHH. x is 4 element vector with x(1) = V, x(2) = n,
% x(3) = m, and x(4) = h

%% setup diff equations
prime    = zeros(4,1);
prime(1) = (I - g(1)*(x(2)^4)*(x(1)-E(1)) - g(2)*(x(3)^3)*(x(4))*(x(1)-E(2)) - g(3)*(x(1)-E(3)))/C; 
prime(2) = (0.01*(10-x(1))/(exp((10-x(1))/10)-1))*(1-x(2)) - (0.125*exp(-(x(1))/80))*x(2);
prime(3) = (0.1*(25-x(1))/(exp((25-x(1))/10)-1))*(1-x(3)) - (4*exp(-x(1)/18))*x(3);
prime(4) = (0.07*exp(-x(1)/20))*(1-x(4)) - 1/(exp((30-x(1))/10)+1)*x(4);

%% end