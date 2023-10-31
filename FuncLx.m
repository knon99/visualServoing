function [Lx] = FuncLx(x,y,Z)

Lx = zeros(2,6);

Lx(1,1) = -1/Z;
Lx(1,2) = 0;
Lx(1,3) = x/Z;
Lx(1,4) = x*y;
Lx(1,5) = -(1+x^2);
Lx(1,6) = y;

Lx(2,1) = 0;
Lx(2,2) = -1/Z;
Lx(2,3) = y/Z;
Lx(2,4) = 1+y^2;
Lx(2,5) = -x*y;
Lx(2,6) = -x;
