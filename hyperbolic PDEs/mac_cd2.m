function w = mac_cd2 ( a, b, NX, t0, tf, NT, D, f )x = linspace ( a, b, NX+1 );dx = ( b - a ) / NX;t = linspace ( t0, tf, NT+1 );dt = ( tf - t0 ) / NT;mu = D * dt / dx^2;wold = zeros ( 1, NX+1 );wstar = zeros ( 1, NX+1 );wnew = zeros ( 1, NX+1 );for j = 1 : NX+1    wold(j) = ic ( x(j) );end;for n = 1 : NT    for j = 2 : NX        fj = feval ( f, wold(j) );		fjp = feval ( f, wold(j+1) );		wstar(j) = wold(j) - (dt/dx) * ( fjp - fj ) + mu * ( wold(j+1) - 2*wold(j) + wold(j-1) );	end;	wstar(1) = 160;	wstar(NX+1) = 40;		for j = 2 : NX        fjs = feval ( f, wstar(j) );		fjsm = feval ( f, wstar(j-1) );		wnew(j) = 0.5 * ( wold(j) + wstar(j) - (dt/dx) * ( fjs - fjsm ) + mu * ( wstar(j+1) - 2*wstar(j) + wstar(j-1) ) );	end;	wold(2:NX) = wnew(2:NX);end;w = wold;function y = ic ( x )%if ( ( 0 <= x ) & ( x <= 1 ) )%   y = 1 - cos(2*pi*x);%else%   y = 0;%end;if ( ( x <= 0 ) )   y = 160;elseif ( x < 2 )   y = 20 - 20*cos(pi*x/2);else   y = 40;end;