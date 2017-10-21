t = 0:0.1:10*pi;
r = linspace (0, 1, numel (t)); 
z = linspace (0, 1, numel (t));
tx = ty = linspace (-8, 8, 41)';
[xx, yy] = meshgrid (tx, ty);
r = sqrt (xx .^ 2 + yy .^ 2) + eps;
tz = sin (r) ./ r; 
mesh (tx, ty, tz);
