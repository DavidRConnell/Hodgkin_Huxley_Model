function [h1,h2,h3,h4] = plotHHstandard(V,t,E,g)
%used to plot values membrane potential, activation constants, and currents
%for ODEHH.
%
% hi is the handle of the ith subplot axis.

h1 = subplot(411);
plot(t,V(:,1))
hold on
plot([0 t(end)],[E(1) E(1)],'r') %plot equilibrium potentials for K, Na, and Calcium
plot([0 t(end)],[E(2) E(2)],'g')
plot([0 t(end)],[E(3) E(3)],'c')
plot([0 t(end)],[0 0],'k')
hold off
legend('Vmem','E_K','E_{Na}','E_L','0')
title('Membrane Potential')
ylabel('mV')

h2 = subplot(412);
plot(t,V(:,2:4))
title('probabilty of (in)activation')
legend('n','m','h')

cond    = zeros(3,length(t));     %condunctances for k and na
curr    = zeros(3,length(t));     %currentes for k, na, and leak
cond(1,:) = (V(:,2).^4)*g(1);
cond(2,:) = (V(:,3).^3).*(V(:,4))*g(2);
cond(3,:) = g(3);
curr(1,:) = cond(1,:).*(V(:,1)'-E(1));
curr(2,:) = cond(2,:).*(V(:,1)'-E(2));
curr(3,:) = cond(3,:).*(V(:,1)'-E(3));

h3 = subplot(413); %plots Ion currents
plot(t,curr(1:2,:))
hold on
plot(t,sum(curr,1),'k')
title('Currents')
ylabel('\mu A')
legend('I_K', 'I_{Na}','sum (I_K + I_{Na} + I_L)')
hold off

h4 = subplot(414); %plots conductances
plot(t,cond(1:2,:))
title('Conductances')
xlabel('time (ms)')
ylabel('mS/cm^2')
legend('g_K','g_Na')
