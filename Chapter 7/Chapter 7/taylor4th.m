function [wi, ti] = taylor4th ( RHS, t0, x0, tf, N )%TAYLOR4TH   approximate the solution of the initial value problem%%                       x'(t) = RHS( t, x ),    x(t0) = x0%%            using the fourth-order Taylor method - this routine will %            work for a system of first-order equations as well as for %            a single equation%%     calling sequences:%             [wi, ti] = taylor4th ( RHS, t0, x0, tf, N )%             taylor4th ( RHS, t0, x0, tf, N )%%     inputs:%             RHS     string containing name of m-file defining the %                     right-hand side of the differential equation and %                     its first three derivatives with respect to the %                     independent variable;  %                     the prototype for the m-file should be%                            [f, ft, ft2, ft3] = RHS ( t, x )%                     where f is the value of the right-hand side function,%                     ft is the value of the derivative with respect to the %                     independent variable, ft2 is the value of the second %                     derivative and ft3 is the value of the third derivative%             t0      initial value of the independent variable%             x0      initial value of the dependent variable(s)%                     if solving a system of equations, this should be a %                     row vector containing all initial values%             tf      final value of the independent variable%             N       number of uniformly sized time steps to be taken to%                     advance the solution from t = t0 to t = tf%%     output:%             wi      vector / matrix containing values of the approximate %                     solution to the differential equation%             ti      vector containing the values of the independent %                     variable at which an approximate solution has been%                     obtained%neqn = length ( x0 );ti = linspace ( t0, tf, N+1 );wi = [ zeros( neqn, N+1 ) ];wi(1:neqn, 1) = x0';h = ( tf - t0 ) / N;for i = 1:N    [f ft ft2 ft3] = feval ( RHS, t0, x0 );    x0 = x0 + h * f + h^2 * ft / 2 + h^3 * ft2 / 6 + h^4 * ft3 / 24;	t0 = t0 + h;	    wi(1:neqn,i+1) = x0';	end;