function w = water ( a, b, NX, t0, tf, NT )x = linspace ( a, b, NX+1 );dx = ( b - a ) / NX;t = linspace ( t0, tf, NT+1 );dt = ( tf - t0 ) / NT;wold = zeros ( 2, NX+1 );wstar = zeros ( 2, NX+1 );wnew = zeros ( 2, NX+1 );gravd2 = 9.81 / 2;for j = 1 : NX+1    wold(1,j) = 5;end;for n = 1 : NT    for j = 1 : NX        fj = [ wold(2,j); (wold(2,j))^2/wold(1,j) + gravd2 * (wold(1,j))^2 ];		fjp = [ wold(2,j+1); (wold(2,j+1))^2/wold(1,j+1) + gravd2 * (wold(1,j+1))^2 ];	    gjn = [ 0; -0.005*(wold(2,j)/wold(1,j))*abs(wold(2,j)/wold(1,j))*(1+2*wold(1,j)/15)];		wstar(:,j) = wold(:,j) - (dt/dx) * ( fjp - fj ) + dt * gjn;	end;		for j = 2 : NX        fjs = [ wstar(2,j); (wstar(2,j))^2/wstar(1,j) + gravd2 * (wstar(1,j))^2 ];		fjsm = [ wstar(2,j-1); (wstar(2,j-1))^2/wstar(1,j-1) + gravd2 * (wstar(1,j-1))^2 ];	    gjs = [ 0; -0.005*(wstar(2,j)/wstar(1,j))*abs(wstar(2,j)/wstar(1,j))*(1+2*wstar(1,j)/15)];		wnew(:,j) = 0.5 * ( wold(:,j) + wstar(:,j) - (dt/dx) * ( fjs - fjsm ) + dt * gjs );	end;	wold(:,2:NX) = wnew(:,2:NX);	wold(1,1) = wold(1,2);	wold(1,NX+1) = 5+0.5*sin(0.1*t(n+1));	wold(2,1) = 0;	wold(2,NX+1) = wold(2,NX);end;w = wold;