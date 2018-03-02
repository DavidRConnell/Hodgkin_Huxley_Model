function [alpha,bet] = alphabetam(V,n)
  %solves for alpha and beta of n,m, and h as vectors with row 1,2, and 3
  %corresponding to n,m and h respectively
  %for multiHH

  %% set up vectors alpha and beta
  alpha  = zeros(n,3);
  bet    = zeros(n,3);

  %% find alpha values
  alpha(:,1) = (0.01.*(10-V))./(exp((10-V)./10)-1);
  alpha(:,2) = (0.1.*(25-V))./(exp((25-V)./10)-1);
  alpha(:,3) = 0.07.*exp(-V./20);

  %% find beta values
  bet(:,1) = 0.125.*exp(-V./80);
  bet(:,2) = 4.*exp(-V./18);
  bet(:,3) = (exp((30-V)./10)+1).^(-1);
