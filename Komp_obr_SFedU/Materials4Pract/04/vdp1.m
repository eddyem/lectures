% Initialisation of Van der Pol with mu=1
function dydt = vdp1(t,y)
    dydt = [y(2); (1-y(1)^2)*y(2)-y(1)];
endfunction
