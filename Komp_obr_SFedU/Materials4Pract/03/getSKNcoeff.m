function SKN = getSKNcoeff(tabname, imprefix)
%
% SKN = getSKNcoeff(tabname)
%
% Calculate SKN coefficients & plot graphs
%
% parameters:
% tabname - filename with table of dA/dZ
%
% SKN:
% dA = K0 + K1/tg(Z) + K2/sin(Z) - K3*sin(A)/tg(Z) + K4 *cos(delta)*cos(P)/sin(Z)
% dZ = K5 + K6*siz(Z) + K7*cos(Z) + K3*cos(A) + K4*cos(phi)*sin(A)
%
% K0 = A0 - azimuth zero; K1 = L - horiz axe inclination; K2 = k - collimation error;
% K3 = F - lattitude error of vert. axe; K4 = dS - time error
% K5 = Z0 - zenith zero; K6 = d - tube bend; K7 = d1 - cos. tube bend
%
% phi = 43.6535278 - lattitude
% t = LST - Alpha  - hour angle
% P=atan(sin(t)/(tan(phi)*cos(Del)-sin(Del)*cos(t)))  - parallax angle
%
	if(nargin == 1) imprefix = ""; endif
	[Ald Alm Als Deld Delm Dels dAl_S dDel_S dA dZ A Z STh STm STs ] = ...
		textread(tabname, "|%f:%f:%f %f:%f:%f|%f %f|%f %f|%f %f|%f:%f:%f|", ...
		60, "headerlines", 8);
	A = A*pi/180; % all angles here will be in radians
	Z = Z*pi/180;
	Al = pi*(Ald+Alm/60+Als/3600)/180; % right accession
	Delsig = Deld./abs(Deld);   % declination sign
	Del = pi*Delsig.*(abs(Deld)+Delm/60+Dels/3600)/180; % declination
	phi = 43.6535278 * pi / 180; % lattitude
	t = pi*(STh+STm/60+STs/3600)/12 - Al; % hour angle
	P = atan(sin(t)./(tan(phi).*cos(Del)-sin(Del).*cos(t))); % parallax angle
	cont = 1;
	while cont
		printf("\n\n\t\t\t\tIteration %d\n\n", cont);
		onescol = ones(size(dA)); % column with ones - for less square method
		cosZ = cos(Z);
		sinZ = sin(Z);
		cosA = cos(A);
		sinA = sin(A);
		tgZ  = tan(Z);
		Xmatr = [onescol sinZ cosZ cosA cos(phi).*sinA];
		K = Xmatr \ dZ;
		K5 = K(1); K6 = K(2); K7 = K(3); K3 = K(4); K4 = K(5);
		dZSKN = K5 + K6*sinZ + K7*cosZ + K3*cosA + K4*cos(phi)*sinA; % dZ by SKN
		K4fr = cos(Del).*cos(P)./sinZ; % K4 multiplier
		dASKN34 = dA + K3*sinA./tgZ - K4*K4fr; % dA components fixed by K3 & K4
		Xmatr = [onescol 1./tgZ 1./sinZ];
		K = Xmatr \ dASKN34;
		K0 = K(1); K1 = K(2); K2 = K(3);
		SKN = [K0, K1, K2, K3, K4, K5, K6, K7];
		dASKN = K0 + K1./tgZ + K2./sinZ - K3*sinA./tgZ + K4*K4fr;
		ddA = dA - dASKN;
		ddZ = dZ - dZSKN;
		sddA = std(ddA); sddZ = std(ddZ);
		mddA = median(ddA); mddZ = median(ddZ);
		printf("sigma(dda) = %f, sigma(ddZ) = %f\n", sddA, sddZ);
		%printf("mean(dda) = %f, mean(ddZ) = %f\n", mean(ddA), mean(ddZ));
		printf("median(dda) = %f, median(ddZ) = %f\n", mddA, mddZ);
		surge = find(abs(ddA - mddA) > 2*sddA);
		ssz = size(surge,1);
		if(ssz != 0)
			printf("Surges: \n")
			for i = 1:ssz
				idx = surge(i);
				printf("%f (Z = %f, A = %f)\n", ddA(idx), Z(idx)*180/pi, A(idx)*180/pi);
			endfor
			Z(surge) = []; A(surge) = []; Al(surge) = []; Del(surge) = [];
			t(surge) = []; P(surge) = []; dZ(surge) = []; dA(surge) = [];
			++cont;
		else
			cont = 0;
		endif
	endwhile
	printf("SKN coefficients: K0..K7: %f, %f, %f, %f, %f, %f, %f, %f\n", ...
		K0, K1, K2, K3, K4, K5, K6, K7);
	fg = figure;
	plot(A*180/pi, [ddA ddZ], 'o');
	legend("ddA", "ddZ");
	xlabel("A, degr"); ylabel("Remaining error: real-model");
	plotgr(sprintf("%s_%s", imprefix, "diff_vs_A"), fg);
	fg = figure;
	plot(Z*180/pi, [ddA ddZ], 'o');
	legend("ddA", "ddZ");
	xlabel("Z, degr"); ylabel("Remaining error: real-model");
	plotgr(sprintf("%s_%s", imprefix, "diff_vs_Z"), fg);
endfunction

function plotgr(nm, fg)
	print(fg, '-dpdf', sprintf("%s.pdf", nm));
	print(fg, '-dpng', sprintf("%s.png", nm));
endfunction
