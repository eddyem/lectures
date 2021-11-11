function C = checkX(x)
	if(x < -5) C = sprintf("%d less than -5\n", x);
	elseif (x > 5) C = sprintf("%d more than 5\n", x);
	else C = sprintf("%d between -5 and 5\n", x);
	endif;
endfunction