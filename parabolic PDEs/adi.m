function w = adi ( a, b, NX, c, d, NY, t0, tf, NT, D, bcx, bcy, f, source, decay )x = linspace ( a, b, NX+1 );y = linspace ( c, d, NY+1 );delta = ( b - a ) / NX;dt = ( tf - t0 ) / NT;dtd2 = dt / 2;lambda = D * dtd2 / delta^2;wold = zeros ( NX+1, NY+1 );wnew = zeros ( NX+1, NY+1 );for j = 2 : NX    for k = 2 : NY        wold(j,k) = feval ( f, x(j), y(k) );	end;end;for j = 1 : NX+1    [ wold(j,1), wold(j,NY+1) ] = feval ( bcy, x(j), t0 );end;for k = 2 : NY    [ wold(1,k), wold(NX+1,k) ] = feval ( bcx, y(k), t0 );end;subx = -lambda * ones ( 1, NX-2 );superx = subx;suby = -lambda * ones ( 1, NY-2 );supery = suby;for n = 2 : NT + 1    for k = 2 : NY	    [ wnew(1,k) wnew(NX+1,k) ] = feval ( bcx, y(k), t0 + ( n - 1.5 ) * dt );		rhsx(1:NX-1) = lambda * ( wold (2:NX, k-1) + wold (2:NX, k+1) );		diagx = ( 1 + 2 * lambda ) * ones ( 1, NX-1 );		for j = 2 : NX		    sterm = (dt/4) * ( feval ( source, x(j), y(k), t0+(n-2)*dt) + feval ( source, x(j), y(k), t0+(n-1.5)*dt) );		    rhsx(j-1) = rhsx(j-1) + ( 1 - 2 * lambda - (dt/4) * feval(decay, x(j), y(k), t0+(n-2)*dt) ) * wold(j, k) + sterm;		    diagx(j-1) = diagx(j-1) + (dt/4) * feval(decay, x(j), y(k), t0+(n-1.5)*dt);		end;		rhsx(1) = rhsx(1) + lambda * wnew(1,k);		rhsx(NX-1) = rhsx(NX-1) + lambda * wnew(NX+1,k);		wnew(2:NX,k) = tridiagonal ( subx, diagx, superx, rhsx )';	end;		for j = 2 : NX	    [ wold(j,1) wold(j,NY+1) ] = feval ( bcy, x(j), t0 + ( n - 1 ) * dt );		rhsy(1:NX-1) = lambda * ( wnew (j-1, 2:NY) + wnew (j+1, 2:NY) );		diagy = ( 1 + 2 * lambda ) * ones ( 1, NY-1 );		for k = 2 : NY		    sterm = (dt/4) * ( feval ( source, x(j), y(k), t0+(n-1.5)*dt) + feval ( source, x(j), y(k), t0+(n-1)*dt) );		    rhsy(k-1) = rhsy(k-1) + ( 1 - 2 * lambda - (dt/4) * feval(decay, x(j), y(k), t0+(n-1.5)*dt) ) * wnew(j, k) + sterm;			diagy(k-1) = diagy(k-1) + (dt/4) * feval(decay, x(j), y(k), t0+(n-1)*dt);		end;		rhsy(1) = rhsy(1) + lambda * wold(j,1);		rhsy(NX-1) = rhsy(NX-1) + lambda * wold(j,NY+1);		wold(j,2:NY) = tridiagonal ( suby, diagy, supery, rhsy );	end;	end;for k = 1 : NY+1    [ wold(1,k), wold(NX+1,k) ] = feval ( bcx, y(k), tf );end;w = wold;