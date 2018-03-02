function [h1,h2] = plotcurrHH(V,t,E,g,Ilen,Istr)
%plots membrane potential and input currents for ODE45
%hi is the axis for the ith subplot

h1 = subplot(211);
plot(t,V(:,1))
hold on
plot([0 t(end)],[E(1) E(1)],'r')
plot([0 t(end)],[E(2) E(2)],'g')
plot([0 t(end)],[E(3) E(3)],'c')
plot([0 t(end)],[0 0],'k')
hold off
legend('Vmem','E_K','E_{Na}','E_L','0')
xlabel('time (ms)')
ylabel('membrane potential (mV)')

I_in = zeros(1,round(t(end)*100)); %increase resolution since many times are less than 1ms
Ilen = Ilen*100;
strt = 1;
end1 = strt + Ilen(1);
for i = 1:length(Ilen)-1
    if mod(i,2) ~= 0   %no input current during odd iters
        I = 0;
    else
        I = Istr(i/2); %set input current
    end
    I_in(strt:end1) = I;
    strt = end1 + 1;
    if i < length(Ilen) - 1
        end1  = strt + Ilen(i+1)-1;
    else
        end1 = length(I_in);
    end
end

h2 = subplot(212);
plot((1:round(t(end)*100))/100,I_in)
xlabel('time (ms)')
ylabel('input current (\mu A)')
