function two_grid ( a, b, N, c, d, M, num_cycle, num_sweep )x = linspace ( a, b, N+1 );y = linspace ( c, d, M+1 );h = (b-a)/N; hsq = h*h;f = zeros ( N+1, M+1 );for i = 2:N     for j = 2:M 	    f(i,j) = -52 * cos ( 4*x(i) + 6*y(j) ); 	end; end;u = zeros ( N+1, M+1 );for i = 1 : N+1    u(i,1)   = cos ( 4*x(i) );	u(i,M+1) = cos ( 4*x(i) + 6 );end;for j = 2 : M    u(1,j)   = cos ( 6*y(j) );	u(N+1,j) = cos ( 6*y(j) + 4 );end;cor = zeros ( N+1, M+1 );res = zeros ( N/2+1, M/2+1 );r = zeros ( N+1, M+1 );for cycles = 1 : num_cycle    for sweeps = 1 : num_sweep        for j = 2 : M	        for i = 2 : N		        temp = 0.25 * ( -hsq*f(i,j) + u(i-1,j) + u(i+1,j) + u(i,j-1) + u(i,j+1) );			    r(i,j) = f(i,j) - ( u(i-1,j) + u(i+1,j) + u(i,j-1) + u(i,j+1) - 4*u(i,j) ) / hsq;			    u(i,j) = temp;		    end;	    end;	    sqrt ( sum ( sum ( r .* r ) ) / ((M-1)*(N-1)) )    end;    for i = 3 : 2 : N-1	    for j = 3 : 2 : M-1            res((i+1)/2, (j+1)/2) = f(i,j) - ( u(i-1,j) + u(i+1,j) + u(i,j-1) + u(i,j+1) - 4*u(i,j) ) / hsq;		end;	end;		v = csolve ( N/2, M/2, 2*h, res );		for i = 2 : N	    for j = 2 : M		    if ( mod(i+1,2) == 0 )			   if ( mod(j+1,2) == 0 )			      cor(i,j) = v((i+1)/2, (j+1)/2);			   else			      cor(i,j) = 0.5 * ( v((i+1)/2, j/2) + v((i+1)/2, (j+2)/2) );			   end;			else			   if ( mod(j+1,2) == 0 )			      cor(i,j) = 0.5 * ( v(i/2, (j+1)/2) + v((i+2)/2, (j+1)/2) );			   else			      cor(i,j) = 0.25 * ( v(i/2, j/2) + v(i/2, (j+2)/2) + v((i+2)/2, j/2) + v((i+2)/2, (j+2)/2) );			   end;			end;		end;	end;    u = u + cor;end;function v = csolve ( N, M, h, res )hsq = h*h;w = zeros ( M+1, N+1 );diag = 4 * eye ( N-1 );for i = 1 : N-2    diag(i+1,i) = -1;	diag(i,i+1) = -1;end;A = zeros ( (N-1)*(M-1), (N-1)*(M-1) );for i = 1 : M-1    A ( 1+(i-1)*(N-1):i*(N-1), 1+(i-1)*(N-1):i*(N-1) ) = diag;end;for i = 1 : M-2    A ( 1+(i-1)*(N-1):i*(N-1), 1+i*(N-1):(i+1)*(N-1) ) = - eye ( N-1 );	A ( 1+i*(N-1):(i+1)*(N-1), 1+(i-1)*(N-1):i*(N-1) ) = - eye ( N-1 );end;for j = 1 : M-1    for i = 1 : N-1	    loc = i + (j-1)*(N-1);		b(loc) = -hsq * res(i+1,j+1);	end;end;[A, pvt] = factor ( A );w1 = solve ( A, b, pvt );for loc = 1 : (N-1)*(M-1)    r = 1 + floor ( (loc-1) / (N-1) );	c = 1 + mod ( (loc-1), (N-1) );	w(r+1,c+1) = w1(loc);end;v = w';return;