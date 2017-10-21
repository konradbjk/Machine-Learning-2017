  n_u = 3; n_m = 4; n = 5;
  X = reshape(sin(1:n_m*n), n_m, n);
  Theta = reshape(cos(1:n_u*n), n_u, n);
  Y = reshape(sin(1:2:2*n_m*n_u), n_m, n_u);
  R = Y > 0.5;
  pval = [abs(Y(:)) ; 0.001; 1];
  yval = [R(:) ; 1; 0];
  params = [X(:); Theta(:)];


[out1a out1b] = estimateGaussian(X);
[out2a out2b] = selectThreshold(yval, pval);
 [out3]= cofiCostFunc(params, Y, R, n_u, n_m, ...
                       n, 0);
[J out4]= cofiCostFunc(params, Y, R, n_u, n_m, ...
                       n, 0);
[out5]= cofiCostFunc(params, Y, R, n_u, n_m, ...
                       n, 1.5);
[J out6]= cofiCostFunc(params, Y, R, n_u, n_m, ...
                       n, 1.5);
  
  save 'results.mat' out1a out1b out2a out2b out3 out4 out5 out6;

