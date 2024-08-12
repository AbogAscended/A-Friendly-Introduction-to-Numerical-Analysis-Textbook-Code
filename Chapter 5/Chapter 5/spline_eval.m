function y = spline_eval ( sp, x )%SPLINE_EVAL      evaluate a given spline function at a specified set of %                 values for the independent variable%%     calling sequences:%             y = spline_eval ( sp, x )%             spline_eval ( sp, x )%%     inputs:%             sp      matrix containing the information which defines the%                     spline function%                     - typically this will be the output from either%                       LINEAR_SPLINE, CUBIC_NAK or CUBIC_CLAMPED%             x       value(s) of independent variable at which to%                     evalaute the spline function%                     - may be a scalar or a vector%%     output:%             y       value(s) of the spline function%%     NOTE:%             this is a companion routine to the routines CUBIC_NAK,%             CUBIC_CLAMPED and LINEAR SPLINE%[p c] = size ( sp );npts = length ( x );for i = 1 : npts    piece = max ( find ( sp(1:p-1) < x(i) ) );    if ( length ( piece ) == 0 )       piece = 1;    end    temp(i) = sp(piece,2) + sp(piece,3) * ( x(i) - sp(piece,1) );    if ( c == 5 )       temp(i) = temp(i) + sp(piece,4) * ( x(i) - sp(piece,1) )^2;	   temp(i) = temp(i) + sp(piece,5) * ( x(i) - sp(piece,1) )^3;    endendif ( nargout == 0 )   disp ( temp )else   y = temp;end