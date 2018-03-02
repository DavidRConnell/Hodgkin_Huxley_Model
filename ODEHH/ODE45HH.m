function [V,t] = ODE45HH(Istr,Ilen,V0,q,g,E,C)
%uses ode45 to solve hudgkin huxley equations. Istr is strength of input 
%current and Ilen is length of input current in 3 element vector. Ilen(1)
%is time before current, Ilen(2) is time of current, and Ilen(3) is time to
%run simulation after current.
%
%for multiple currents Istr has length equal to number of currents. Ilen is
%vector with number of currents time 2 + 1 elements. Where elements
%alternate between time between current and time of current and the last
%element is the how long to continue simulation after last current.
%
% times in ms

%% check inputs
assert(mod(length(Ilen),2) ~= 0,'expected Ilen to have an odd number of dimensions')

%% solve ode
n = length(Ilen);
out(n+1).V = 0; %preallocate out structure
out(n+1).t = 0;
out(1).V = [V0 q']; %set intial conditions
out(1).t = 0;
for iter = 1:n
    if mod(iter,2) ~= 0 %no input current during odd iters
        I = 0;
    else 
        I = Istr(iter/2); %set input current
    end
    V0 = out(iter).V(end,:);
    tspan = [0 Ilen(iter)];
    [out(iter+1).t,out(iter+1).V] = ode45(@dsolveHH,tspan,V0,[],g,E,C,I);
    out(iter+1).t = out(iter).t(end) + out(iter+1).t;
end

%% set outputs
len = 0;
for iter = 1:n %find length of V and t
    len = len + length(out(iter+1).t);
end
V = zeros(len,4); %preallocate V and t
t = zeros(len,1); 
V(1,:) = out(1).V;
t(1)   = out(1).t;
strt = 2;
end1 = 1 + length(out(2).t);
for iter = 1:n
    V(strt:end1,:) = out(iter+1).V;
    t(strt:end1) = out(iter+1).t;
    strt = end1 + 1;
    if iter < n
        end1 = strt-1 + length(out(iter+2).t);
    else end1 = len;
    end
end

%% end