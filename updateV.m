function Vout = updateV(Vin,C,I_in,gK_bar,gNa_bar,gL_bar,E_K,E_Na,E_L,dt,q)
  %updates the voltage using the differtial equation
  %C*(dV/dt) = I_in + gK_bar*n^4*(V-E_K) + gNa_bar*m^3*h*(V-E_Na) + gL_bar(V-E_L)
  %with an iterative approach. i.e solving for dV by multiplying both sides by dt
  
  Im    = gK_bar*(q(1)^4)*(Vin-E_K) + gNa_bar*(q(2)^3)*q(3)*(Vin-E_Na) + gL_bar*(Vin-E_L);
  dV    = I_in - Im;
  dV    = dV*dt/C;
  Vout  = Vin + dV;
