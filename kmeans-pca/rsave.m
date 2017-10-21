  X = reshape(sin(1:165), 15, 11);
  Z = reshape(cos(1:121), 11, 11);
  C = Z(1:5, :);
  idx = (1 + mod(1:15, 3))';

  out1 = findClosestCentroids(X, C);
  out2= centroids = computeCentroids(X, idx, 3);
  [out3a out3b] = pca(X);
  out4 = projectData(X, Z, 5);
  out5 = recoverData(X(:,1:5), Z, 5);
  
  save 'results.mat' out1 out2 out3a out3b out4 out5;

