function [w, x, y, rn] = ell_jac ( a, b, N, c, d, M, f, g, TOL, Nmax )%ELL_JAC      approximate the solution of the elliptic partial differential%             equation%%                    u_xx + u_yy = f(x,y),%%             defined over a rectangular domain, subject to the Dirichlet %             boundary conditions%%                    u(x,y) = g(x,y)         %%             around the entire boundary, using the finite difference method %             with Jacobi relaxation%%%     calling sequences:%             [w, x, y] = ell_jac ( a, b, N, c, d, M, f, g, TOL, Nmax )%             [w, x, y, rn] = ell_jac ( a, b, N, c, d, M, f, g, TOL, Nmax )%%     inputs:%             a       left endpoint of problem domain in x-direction%             b       right endpoint of problem domain in x-direction%             N       number of uniformly-sized subintervals in x-direction%             c       lower endpoint of problem domain in y-direction%             d       upper endpoint of problem domain in y-direction%             M       number of uniformly-sized subintervals in y-direction%             f       string containing name of m-file defining the %                     right-hand side of the differential equation; %                     function should take two inputs and return a single%                     output value%             g       string containing name of m-file defining the %                     Dirichlet boundary conditions; function should take %                     two inputs and return a single output value%             TOL     convergence tolerance for Jacobi relaxation; %                     applied to the maximum norm of the difference between%                     successive approximations%             Nmax    maximum number of iterations of Jacobi relaxation%                     to be performed to achieve convergence%%     output:%             w       matrix of dimension (N+1) x (M+1) containing the %                     approximate values of the solution of the partial%                     differential equation%             x       vector of length N+1 containing the x-values of the%                     computational grid%             y       vector of length M+1 containing the y-values of the%                     computational grid%             rn      vector containing the residual norm associated with%                     each iteration of Jacobi relaxation%%     NOTE:%             It is assumed that the values of N and M have been specified%             so that (b-a)/N = (d-c)/M%x = linspace ( a, b, N+1 );y = linspace ( c, d, M+1 );h = (b-a)/N;hsq = h*h;if ( nargout > 3 ) rn = zeros ( 1, Nmax ); end;%%   load boundary values around edge of solution matrix%wold = zeros ( N+1, M+1 );for i = 1 : N+1    wold(i,  1) = feval ( g, x(i), y(1) );	wold(i,M+1) = feval ( g, x(i), y(M+1) );end;for j = 2 : M    wold(1,  j) = feval ( g, x(1), y(j) );	wold(N+1,j) = feval ( g, x(N+1), y(j) );end;% %   load h^2 times value of right-hand side function into a%   matrix for lookup%fmat = zeros ( N+1, M+1 );for i = 2 : N    for j = 2 : M	    fmat(i,j) = hsq * feval ( f, x(i), y(j) );	end;end;%%   perform Jacobi relaxation%for its = 1 : Nmax    res_norm = 0;	for i = 2 : N	    for j = 2 : M            new = 0.25 * ( wold(i-1,j) + wold(i+1,j) + wold(i,j-1) + wold(i,j+1) - fmat(i,j) );            res = wold(i,j) - new;			wnew(i,j) = new;			if ( abs ( res ) > res_norm ) res_norm = abs(res); end;		end;	end;		wold(2:N,2:M) = wnew(2:N,2:M);	if ( nargout > 3 ) rn(its) = res_norm; end;	if ( res_norm < TOL ) w = wold; disp(its); return; end;end;w = wold; 	   