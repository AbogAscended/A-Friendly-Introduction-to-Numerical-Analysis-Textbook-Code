function [wi, ti] = bdf2 ( RHS, DER, t0, x0, tf, N, TOL, Nmax )%BDF2      approximate the solution of the initial value problem%%                       x'(t) = RHS( t, x ),    x(t0) = x0%%          using the second-order backward differentiation formula - %          this routine will work for a system of first-order equations %          as well as for a single equation;  Newton's method is used %          to solve the implicit equation which arises at each time step%%%     calling sequences:%             [wi, ti] = bdf2 ( RHS, DER, t0, x0, tf, N, TOL, Nmax )%             bdf2 ( RHS, DER, t0, x0, tf, N, TOL, Nmax )%%     inputs:%             RHS     string containing name of m-file defining the %                     right-hand side of the differential equation;  the%                     m-file must take two inputs - first, the value of%                     the independent variable; second, the value of the%                     dependent variable%             DER     string containing name of m-file defining the %                     derivative of the right-hand side of the differential %                     equation with respect to the dependent variable;  the%                     m-file must take two inputs - first, the value of%                     the independent variable; second, the value of the%                     dependent variable%                     NOTE:  in the case of a system of equations, this%                            function defines the Jacobian of the system%             t0      initial value of the independent variable%             x0      initial value of the dependent variable(s)%                     if solving a system of equations, this should be a %                     row vector containing all initial values%             tf      final value of the independent variable%             N       number of uniformly sized time steps to be taken to%                     advance the solution from t = t0 to t = tf%             TOL     convergence tolerance applied to Newton's method at%                     each time step%             Nmax    maximum number of iterations of Newton's method to%                     be performed at each time step%%     output:%             wi      vector / matrix containing values of the approximate %                     solution to the differential equation%             ti      vector containing the values of the independent %                     variable at which an approximate solution has been%                     obtained%%     dependencies:%           %             when applied to a system of equations, this routine makes use%             of the routines LUFACTOR and LUSOLVE from the "systems of%             equations" library%neqn = length ( x0 );ti = [ t0 zeros( 1, N ) ];wi = [ zeros( neqn, N+1 ) ];wi(1:neqn, 1) = x0';h = ( tf - t0 ) / N;%%  generate w1 using the Backward Euler method  %  with extrapolation%[w1 temp] = back_euler ( 'RHS', 'DER', t0, x0, t0+h, 1, TOL, Nmax );[w2 temp] = back_euler ( 'RHS', 'DER', t0, x0, t0+h, 2, TOL, Nmax );x0 = ( 2 * w2(1:neqn, 3) - w1(1:neqn, 2) )';%[temp w1] = ode_trap ( 'RHS', 'DER', t0, x0, t0+h, 1, TOL, Nmax );%x0 = w1(1:neqn,2)';t0 = t0 + h;ti(2) = t0;wi(1:neqn,2) = x0';	%%  perform remaining time steps using BDF2%if ( neqn == 1 )   for i = 2:N       w0 = x0;	   x1 = wi(1:neqn, i-1)';	   for j = 1:Nmax           top = (w0 - (4/3) * x0 + (1/3) * x1 ) - (2/3) * h * feval ( RHS, t0+h, w0 );		   bot = 1 - (2/3) * h * feval ( DER, t0+h, w0 );		   dw = top / bot;		   w0 = w0 - dw;		   if ( abs ( dw ) < TOL ) break; end;	   end;	   x0 = w0;	   t0 = t0 + h;       ti(i+1) = t0;       wi(1:neqn,i+1) = x0';	   end;else   for i = 2:N       w0 = x0;	   x1 = wi(1:neqn, i-1)';	   for j = 1:Nmax           frhs = (w0 - (4/3) * x0 + (1/3) * x1) - (2/3) * h * feval ( RHS, t0+h, w0 );		   jac = eye(neqn) - (2/3) * h * feval ( DER, t0+h, w0 );		   [lu pvt] = LUfactor ( jac );		   dw = LUsolve ( lu, -frhs, pvt);		   w0 = w0 + dw;		   if ( max ( abs ( dw ) ) < TOL ) break; end;	   end;	   x0 = w0;	   t0 = t0 + h;       ti(i+1) = t0;       wi(1:neqn,i+1) = x0';	   end;end;