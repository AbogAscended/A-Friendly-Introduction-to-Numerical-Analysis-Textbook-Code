function [lambda, v] = inv_sympower ( A, q, x, TOL, Nmax )%INV_SYMPOWER   approximate the eigenvalue nearest to the number q, %               and an associated eigenvector, for a symmetric matrix %               using the inverse power method%%     calling sequences:%             [lambda, v] = inv_sympower ( A, q, x, TOL, Nmax )%             lambda = inv_sympower ( A, q, x, TOL, Nmax )%             inv_sympower ( A, q, x, TOL, Nmax )%%     inputs:%             A       square symmetric matrix whose eigenvalue nearest %                     to the value q is to be approximated%             q       approximation to an eigenvalue of A%             x       initial approximation to eigenvector corresponding%                     to the eigenvalue nearest to q%             TOL     absolute error convergence tolerance%                     (convergence is measured in terms of the Euclidean%                     norm of the difference between successive terms %                     in the eigenvector seqeunce)%             Nmax    maximum number of iterations to be performed%%     outputs:%             lambda  approximation to dominant eigenvalue of A%             v       an eigenvector of A corresponding to the eigenvalue%                     lambda - vector will be normalized to unit length%                     in the Euclidean norm%%     dependencies:%             this routine makes use of both LUfactor and LUsolve from %             "Systems of Equations" library%%     NOTE:%             if INV_SYMPOWER is called with no output arguments, the %             iteration number, the current eigenvector approximation, %             the current eigenvalue approximation and an estimate of %             the rate of convergence of the eigenvalue sequence will%             be displayed%%             if the maximum number of iterations is exceeded, a message%             to this effect will be displayed and the most recent%             approximations to the eigenvalue nearest to q and its %             corresponding eigenvector will be returned in the output values%[r c] = size ( A );[rx rc] = size ( x );if ( rc == 1 ) x = x'; rc = rx; end;if ( r ~= c )   disp ( 'inv_sympower error: matrix must be square' );   return;elseif ( r ~= rc )   disp ( 'inv_sympower error: dimensions of matrix and vector are not compatible' );   return;end;x = x / sqrt ( sum ( x .* x ) );mu_old = 0;if ( nargout == 0 )   s = sprintf ( '%3d \t %10f ', 0, x(1) );   for j = 2 : rc 	   s = sprintf ( '%s%10f ', s, x(j) );   end;   disp ( s );end;[lu pvt] = LUfactor ( A - q*eye(rc) );for i = 1 : Nmax    xnew = LUsolve ( lu, x, pvt );	mu =  sum ( x .* xnew );    xnew = xnew / sqrt ( sum ( xnew .* xnew ) );		if ( nargout == 0 )	   s = sprintf ( '%3d \t %10f ', i, xnew(1) );	   for j = 2 : rc 	       s = sprintf ( '%s%10f ', s, xnew(j) );	   end;	   s = sprintf ( '%s \t %10f', s, 1/mu+q );	   if ( i >= 3 ) s = sprintf ( '%s \t \t %10f', s, abs((mu-mu_old)/(mu_old-mu_older)) ); end;	   disp ( s );	end;		delta = x - sign(mu) * xnew;	err = sqrt ( sum ( delta .* delta ) );	if ( err < TOL )	   if ( nargout >= 1 ) lambda = 1/mu+q; end;	   if ( nargout >= 2 ) v = xnew; end;	   return;	else    	   x = xnew;	   mu_older = mu_old;	   mu_old = mu;	end;	end;disp ( 'inv_sympower error: Maximum number of iteration exceeded' );if ( nargout >= 1 ) lambda = 1/mu+q; end;if ( nargout >= 2 ) v = xnew; end;