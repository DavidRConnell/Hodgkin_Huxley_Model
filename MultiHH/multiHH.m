close all; clearvars;
%% help
% multiHH simulates multiple hodgkin-huxley modeled neurons connected to each other.
% The number of connections and their strengths are randomly generated.

%% constants
% Simulation constants
n    = 50;     %number of neurons
dt   = 0.01;   %step size dt of 1 = 0.01ms
t    = 1500;   %length of sim in ms/100

% Neuron constants (from Dynamical Systems in Neuroscience)
C      = 1;                                  %capacitance in uF
gK_bar = 36;  gNa_bar = 120; gL_bar = 0.3;   %max conductances in mS/cm^2
E_K    = -12; E_Na    = 115; E_L    = 10.6;  %Nernst equilibrium constants in mV note: hodgkin-huxley shifted V_rest to zeros
R      = 34;                                 %length depedent resistance Ohms/cm from MEMBRANE AND PROTOPLASM RESISTANCE IN THE
                                             %SQUID GIANT AXON

% input stimulus
ex             = 200;            %extra time I_in is generated. Accounts for propagation time ~2ms
I_in           = zeros(n,t+ex);
I_in(1,t:t+ex) = 100;            %sets initial input for neuron 1. Starts initial action potential


%% Initial conditions
V       = zeros(n,1);       %resting membrane potential
[a,b]   = alphabetam(V,n);  %alpha and beta at resting potentials
q       = a./(b + a);       %(in)activation constants, rows contain n,m, and h respectively
                            % n,m,h assume steady-state at rest to solve for q

%connection constants for the neurons
Const = rand(n,n);                       %randomly generates connection constants between zero and one (relative connection strength)
Const = 15*Const.*(1-eye(n,n));          %sets diag to zero so neurons don't set off themselves (15 infront increases reaction to action potential)
Const = Const.*round((rand(n,n) - 0.4)); %removes some neuron connections. Not all neurons should be connected to each other

%Change time constants
cht              = 4*rand(n,1);    %increasing a and b decreases time constant, increasing responsivness
cht(cht < 0.5)   = 0.5;            %max value for time constant, otherwise some action potentials are to large as tau approaches zero

%% initialize iteration
V_save  = zeros(n,t); %saves store V and q values for plotting purposes
t_stamp = -t;         %used to flip time. i.e so newest points move from right to left
iter    = -1;

%% initialize figure
h  = zeros(1,n); %fig handles
ax = zeros(1,n);

for i = 1%:ceil(n/5) %uncomment and at drawnow for loop for multiple figures
 figure(i)
 ax(5*(i-1)+1)  = subplot(511);
 h(5*(i-1)+1)   = plot(nan,'-');
 xlabel 'ms'
 ylabel 'mV'
 title(['membrane potential of neurons ',num2str(5*(i-1)+1),' through ',num2str(5*(i-1)+5)])
 set(gca,'ylim',[-40,120])

 ax(5*(i-1)+2)  = subplot(512);
 h(5*(i-1)+2)   = plot(nan,'-');
 xlabel 'ms'
 ylabel 'mV'
 set(gca,'ylim',[-40,120])

 ax(5*(i-1)+3)  = subplot(513);
 h(5*(i-1)+3)   = plot(nan,'-');
 xlabel 'ms'
 ylabel 'mV'
 set(gca,'ylim',[-40,120])

 ax(5*(i-1)+4)  = subplot(514);
 h(5*(i-1)+4)   = plot(nan,'-');
 xlabel 'ms'
 ylabel 'mV'
 set(gca,'ylim',[-40,120])

 ax(5*(i-1)+5)  = subplot(515);
 h(5*(i-1)+5)   = plot(nan,'-');
 xlabel 'ms'
 ylabel 'mV'
 set(gca,'ylim',[-40,120])
end

ax = ax(ax ~= 0);      %removes unused ax handles
linkaxes(ax,'x')

figure                 %plots current voltage of all neurons
g = stem(nan, '*');
xlabel 'neuron'
ylabel 'membrane potential (mV)'
title(['membrane potential of all ',num2str(n),' neurons'])
set(gca,'ylim',[0 120])
set(gca,'xlim',[1,n])

%% start iteration
while (1)
 iter               = iter + 1;
 t_stamp            = t_stamp + 1;
 V_save(:,1:end-1)  = V_save(:,2:end);
 V_save(:,end)      = V;

 if iter > 0;
  I_in(:,1:end-1)    = I_in(:,2:end);
  I_hold             = Const*(V/R);
  I_hold(I_hold < 0) = 0;
  I_in(:,end)        = I_hold;         %prevents from sending negative values
 end

 V      = updateVm(V,C,I_in(:,end-ex),gK_bar,gNa_bar,gL_bar,E_K,E_Na,E_L,dt,q);
 [a,b]  = alphabetam(V,n);
 a      = bsxfun(@times,a,cht);        %changes time constants
 b      = bsxfun(@times,b,cht);
 q      = updateq(q,a,b,dt);

 if mod(iter,20) == 0
  for i = 1%:ceil(n/5)
   tdata = (t_stamp+1:t_stamp+t)*0.01; tlim = [t_stamp+1,t_stamp+t]*0.01;        %converts to ms

   set(h(5*(i-1)+1),'xdata',tdata,'ydata',V_save((5*(i-1)+1),:))
   set(h(5*(i-1)+2),'xdata',tdata,'ydata',V_save((5*(i-1)+2),:))
   set(h(5*(i-1)+3),'xdata',tdata,'ydata',V_save((5*(i-1)+3),:))
   set(h(5*(i-1)+4),'xdata',tdata,'ydata',V_save((5*(i-1)+4),:))
   set(h(5*(i-1)+5),'xdata',tdata,'ydata',V_save((5*(i-1)+5),:))
   set(ax(1),'xlim',tlim)
  end

  set(g,'xdata',(1:n),'ydata',V)
  drawnow

 end
end
