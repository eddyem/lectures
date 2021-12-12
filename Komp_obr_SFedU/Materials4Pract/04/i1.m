function y = i1 (x)
    y = x .* sin (1./x) .* sqrt (abs (1 - x));
endfunction
