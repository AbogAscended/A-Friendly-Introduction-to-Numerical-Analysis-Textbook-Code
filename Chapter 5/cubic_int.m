function y = cubic_int ( csc );[n temp] = size ( csc );sum = 0;for i = 1 : n-1    h = csc(i+1,1) - csc(i,1);	sum = sum + h*csc(i,2) + h*h*csc(i,3)/2 + h*h*h*csc(i,4)/3 + h*h*h*h*csc(i,5)/4;end;y = sum;