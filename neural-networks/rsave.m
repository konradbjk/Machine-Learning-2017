X = reshape(3 * sin(1:1:30), 3, 10);
Xm = reshape(sin(1:32), 16, 2) / 5;
ym = 1 + mod(1:16,4)';
t1 = sin(reshape(1:2:24, 4, 3));
t2 = cos(reshape(1:2:40, 4, 5));
t  = [t1(:) ; t2(:)];

out1 = nnCostFunction(t, 2, 4, 4, Xm, ym, 0);
out2 = nnCostFunction(t, 2, 4, 4, Xm, ym, 1.5);
out3 = sigmoidGradient(X);
[out4a out4b] = nnCostFunction(t, 2, 4, 4, Xm, ym, 0);
[out5a out5b] = nnCostFunction(t, 2, 4, 4, Xm, ym, 1.5);

  
save 'results.mat' out1 out2 out3 out4a out4b out5a out5b

