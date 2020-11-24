function crv = nrbtestcrv 
% Constructs a simple test curve.  
 
% D.M. Spink 
% Copyright (c) 2000 
 
pnts    = [0.5 1.5 4.5 3.0 7.5 6.0 8.5; 
        3.0 5.5 5.5 1.5 1.5 4.0 4.5; 
        0.0 0.0 0.0 0.0 0.0 0.0 0.0]; 
order   = 4;
m       = size(pnts,2) + order;
% knots   = [0 0 0 1/4 1/2 3/4 3/4 1 1 1];
knots   = [zeros(1,order-1) linspace(0,1,m-2*(order-1)) ones(1,order-1)];

crv     = nrbmak(pnts,knots); 
 
 
 