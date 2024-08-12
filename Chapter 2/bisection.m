function y = bisection ( f, a, b, TOL )%BISECTION   bisection method for locating the root of a nonlinear function%%     calling sequences:%             y = bisection ( 'f', a, b, TOL )%             bisection ( 'f', a, b, TOL )%%     inputs:%             f       string containing name of m-file defining function%                     whose root is to be located%             a,b     left and right endpoints, respectively, of interval%                     known to contain root of f%             TOL     absolute error convergence tolerance%                     (iterations will be performed until the size of%                     enclosing interval is smaller than 2*TOL)%%     output:%             y       approximate value of root%%     NOTE:%             if BISECTION is called with no output arguments, the iteration%             number, the current enclosing interval and the current %             approximation to the root are displayed%fa = feval(f,a);Nmax = floor ( log((b-a)/TOL) / log(2.0) ) + 1for i = 1 : Nmax    p = ( a + b ) / 2.0;	fp = feval(f,p);		if ( nargout == 0 )	   disp ( sprintf ( '\t\t %3d \t (%.6f,%.6f) \t %.10f \n', i, a, b, p ) )	end		if ( (b-a)<2*TOL | fp == 0 ) 	   if ( nargout == 1 )	      y = p;	   end	   return	elseif ( fa * fp < 0 )	   b = p;	else	   a = p;	   fa = fp;	endend