function [w, x, y] = conv_flow ( N, TOL, Nmax )x = linspace ( 0, 3, 6*N+1 );y = linspace ( 0, 2, 4*N+1 );h = 1/N;hsq = h*h;w = zeros ( 6*N+1, 4*N+1 );for i = 1 : 2*N+1	w(i,4*N+1) = 6;end;for i = 2*N+2 : 3*N    w(i,6*N-i+2) = 6;end;for i = 3*N+1 : 6*N+1    w(i,3*N+1) = 6;end;for j = 1 : 4*N    w(1,j) = 3*y(j);end;for j = 2*N+1 : 3*N    w(6*N+1,j) = 12*(y(j)-1);end;fmat = zeros ( 6*N+1, 4*N+1 );lasti = zeros ( 1, 4*N+1 );for j = 2 : 2*N+1    lasti(j) = 2*N + j - 1;end;lasti(2*N+2:3*N) = 6*N;for j = 3*N+1 : 4*N    lasti(j) = 6*N - j + 1;end;for its = 1 : Nmax    res_norm = 0;	for j = 2 : 4*N	    for i = 2 : lasti(j)		    new = 0.25 * ( w(i-1,j) + w(i+1,j) + w(i,j-1) + w(i,j+1) - fmat(i,j) );			res = w(i,j) - new;			w(i,j) = new;			if ( abs ( res ) > res_norm ) res_norm = abs(res); end;		end;	end;		if ( res_norm < TOL ) disp(its); return; end;end; 	   