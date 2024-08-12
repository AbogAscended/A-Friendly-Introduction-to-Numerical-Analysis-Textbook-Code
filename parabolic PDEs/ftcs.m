function [w, x, t] = ftcs ( a,b, NX, t0, tf, NT, D, bc, f, source, decay )x = linspace ( a, b, NX+1 );t = linspace ( t0, tf, NT+1 );dx = (b-a) / NX;dt = (tf-t0) / NT;lambda = D * dt / dx^2;diag = 1 - 2 * lambda;wnew = zeros ( NX+1,1 );wold = zeros ( NX+1,1 );for i = 2 : NX    wold(i) = feval ( f, x(i) );end;[ wold(1), wold(NX+1) ] = feval ( bc, t(1) );for j = 2 : NT+1    for i = 2 : NX	    wnew(i) = lambda * wold(i-1) + ( diag - dt * feval ( decay, x(i), t(j-1) ) ) * wold(i) + lambda * wold(i+1) + dt * feval ( source, x(i), t(j-1) );	end;	[ wnew(1), wnew(NX+1) ] = feval ( bc, t(j) );	wold = wnew;end;w = wnew;