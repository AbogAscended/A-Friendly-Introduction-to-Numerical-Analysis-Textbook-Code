function w = temp_sys ( a, b, NX, t0, tf, NT )x = linspace ( a, b, NX+1 );dx = ( b - a ) / NX;t = linspace ( t0, tf, NT+1 );dt = ( tf - t0 ) / NT;wold = zeros ( 2, NX+1 );wstar = zeros ( 2, NX+1 );wnew = zeros ( 2, NX+1 );wold(1,1) = 1;for n = 1 : NT    for j = 1 : NX        fj = [ wold(2,j); wold(1,j) ];		fjp = [ wold(2,j+1); wold(1,j+1) ];		wstar(:,j) = wold(:,j) - (dt/dx) * ( fjp - fj );	end;		for j = 2 : NX        fjs = [ wstar(2,j); wstar(1,j) ];		fjsm = [ wstar(2,j-1); wstar(1,j-1) ];		wnew(:,j) = 0.5 * ( wold(:,j) + wstar(:,j) - (dt/dx) * ( fjs - fjsm ) );	end;	wold(:,2:NX) = wnew(:,2:NX);%	wold(2,1) = (4*wold(2,2)-wold(2,3))/3;%	wold(2,NX+1) = (4*wold(2,NX)-wold(2,NX-1))/3;    wold(2,1) = wold(2,2);	wold(2,NX+1) = wold(2,NX);end;w = wold;