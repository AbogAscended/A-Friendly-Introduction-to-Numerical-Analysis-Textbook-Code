function [p, q, r] = coeff ( x )%p = 0; %q = -2*x;%r = 3;%h = 100;  k = 186;  t = 0.0085 - x/10;  tp = -1/10;  tinf = 20;%p = -(tp/t + 1/x);%q = 2*h/(k*t);%r = -2*h*tinf/(k*t);%if ( x == 0 )%   p = 0;%   q = 0;%   r = 1/3;%else%   p = -2 / x;%   q = 0;%   r = 1+x^2;%end;th = 0.002 * ( 1 + 0.1/(1 + (x-5)^2) );thp = -0.0004*(x-5) / ( 1 + (x-5)^2 )^2;p = -2 * thp / th;q = 10^(-5) / th;r = -50 * 10^(-5) / th;