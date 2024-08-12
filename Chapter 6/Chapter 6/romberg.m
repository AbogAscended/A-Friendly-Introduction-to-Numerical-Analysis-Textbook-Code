function approx = romberg ( f, a, b, TOL )%ROMBERG    approximate the definite integral of an arbitrary function%           to within a specified error tolerance using the Romberg%           integration (i.e., extrapolation applied to the Trapezoidal%           rule)%%     calling sequences:%             y = romberg ( 'f', a, b, TOL )%             romberg ( 'f', a, b, TOL )%%     inputs:%             f       string containing name of m-file defining integrand%             a       lower limit of integration%             b       upper limit of integration%             TOL     absolute error convergence tolerance%%     output:%             y       approximate value of the definite integral of f(x)%                     over the interval a < x < b%%     NOTE:%             if ROMBERG is called with no output arguments, the approximate %             value of the definite integral of f(x) over the interval %             a < x < b will be displayed, together with the estimate for%             the error in the approximation and the total number of %             function evaluations used%A = zeros ( 20, 20 );A(1,1) = trap ( f, a, b, 1 );h = ( b - a ) / 2;A(2,1) = A(1,1) / 2 + h * feval ( f, a + h );A(2,2) = ( 4 * A(2,1) - A(1,1) ) / 3;errest = abs ( A(2,2) - A(1,1) ) / 2;i = 2;while ( errest > TOL )	i = i + 1;	%   determine trapezoidal rule approximation		h = h / 2;	sum = 0.0;	for j = 1 : 2 : 2^(i-1)-1	    sum = sum + feval ( f, a + j * h );	end;    A(i,1) = A(i-1,1) / 2 + h * sum;	%   complete row of extrapolation table		for j = 2:i	    power = 4^(j-1);		A(i,j) = ( power * A(i,j-1) - A(i-1,j-1) ) / ( power - 1 );	end;	errest = abs ( A(i,i) - A(i-1,i-1) ) / 2^(i-1);end;if ( nargout == 0 )   s = sprintf ( '\t\t approximate value of integral: \t %.12f \n', A(i,i) );   s = sprintf ( '%s \t\t error estimate: \t\t\t\t\t %.4e \n', s, errest );   s = sprintf ( '%s \t\t number of function evaluations: \t %d \n', s, 2^(i-1)+1 );   disp ( s )else   approx = A(i,i); end