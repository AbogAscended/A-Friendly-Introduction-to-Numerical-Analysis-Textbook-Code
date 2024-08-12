function [w, x] = cn_polar2 ( a,b, NX, t0, tf, NT, D, bc, f )r = linspace ( a, b, NX+1 );dr = (b-a) / NX;dt = (tf-t0) / NT;lambda = D * dt / (2 * dr^2);mu = D * dt / ( 2 * dr );wnew = zeros ( NX+1,1 );wold = zeros ( NX+1,1 );for i = 2 : NX    wold(i) = feval ( f, r(i) );end;[ wold(1), wold(NX+1) ] = feval ( bc, t0 );%for i= 2 : NX%    sold(i) = feval ( source, x(i), t0 );%	dold(i) = feval ( decay, x(i), t0 );%end;sub   = -( lambda - 0.5 * mu ./ r(3:NX) );super = -( lambda + 0.5 * mu ./ r(2:NX-1) );for j = 2 : NT+1    [ wnew(1), wnew(NX+1) ] = feval ( bc, t0 + (j-1)*dt );		diag  = ( 1 + 2 * lambda) * ones ( 1, NX-1 ); 		for i = 2 : NX	    rhs(i-1) = ( lambda - 0.5 * mu / r(i) ) * wold(i-1) + ( 1 - 2 * lambda ) * wold(i) + ( lambda + 0.5 * mu / r(i) ) * wold(i+1);%		dold(i) = feval ( decay, x(i), t0 + (j-1)*dt );%		diag(i-1) = diag(i-1) + (dt/2) * dold(i);	end;	rhs(1) = rhs(1) + (lambda-0.5*mu ./ r(2))* ( wnew(1) );	rhs(NX-1) = rhs(NX-1) + (lambda+0.5*mu ./ r(NX))* ( wnew(NX+1) );%	rhs = rhs + (dt/2) * ( sold(2:NX) + snew(2:NX) );	    wnew(2:NX) = tridiagonal ( sub, diag, super, rhs );	wold = wnew;%	sold = snew;end;w = wnew;