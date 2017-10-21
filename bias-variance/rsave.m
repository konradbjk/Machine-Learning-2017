  X = [ones(10,1) sin(1:1.5:15)' cos(1:1.5:15)'];
  y = sin(1:3:30)';
  Xval = [ones(10,1) sin(0:1.5:14)' cos(0:1.5:14)'];
  yval = sin(1:10)';

 out1 = linearRegCostFunction(X, y, [0.1 0.2 0.3]', 0.5);
 [J, out2] = linearRegCostFunction(X, y, [0.1 0.2 0.3]', 0.5);
 [out3a, out3b] =  ...
        learningCurve(X, y, Xval, yval, 1);
 [out4] = polyFeatures(X(2,:)', 8);
 [out5a, out5b, out5c] = ...
        validationCurve(X, y, Xval, yval);
  
  save 'results.mat' out1 out2 out3a out3b out4 out5a out5b out5c;

