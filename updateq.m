function qout = updateq(qin,a,b,dt)
  %uses an iterative approach to update the activation and inactivation varibles
  %n,m, and h

  dq   = a.*(1-qin) - b.*(qin);
  dq   = dq*dt;
  qout = qin + dq;
