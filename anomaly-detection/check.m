function check(partId, webSubmit)
%SUBMIT Submit your code and output to the ml-class servers
%   SUBMIT() will connect to the ml-class server and submit your solution
  fprintf('==\n== [ml-class] Submitting Solutions | Programming Exercise %s\n==\n', ...
          homework_id());
  if ~exist('partId', 'var') || isempty(partId)
    partId = promptPart();
  end

  if ~exist('webSubmit', 'var') || isempty(webSubmit)
    webSubmit = 0; % submit directly by default 
  end

  % Check valid partId
  partNames = validParts();
  if ~isValidPartId(partId)
    fprintf('!! Invalid homework part selected.\n');
    fprintf('!! Expected an integer from 1 to %d.\n', numel(partNames) + 1);
    fprintf('!! Submission Cancelled\n');
    return
  end

  % Setup submit list
  if partId == numel(partNames) + 1
    submitParts = 1:numel(partNames);
  else
    submitParts = [partId];
  end

  for s = 1:numel(submitParts)
    thisPartId = submitParts(s);
    [result your_answer correct_answer] = check_single(thisPartId);
    if result == true
      printf("Dobrze!\n");
    else
      printf("Zle...Powinno byc:\n");
      correct_answer
      printf("A nie: \n");
      your_answer
    end
  end
end

% ================== CONFIGURABLES FOR EACH HOMEWORK ==================

function id = homework_id() 
  id = '8';
end

function [partNames] = validParts()
  partNames = { 'Estimate Gaussian Parameters', ...
                'Select Threshold' ...
                'Collaborative Filtering Cost', ...
                'Collaborative Filtering Gradient', ...
                'Regularized Cost', ...
                'Regularized Gradient' ...
                };
end

function srcs = sources()
  % Separated by part
  srcs = { { 'estimateGaussian.m' }, ...
           { 'selectThreshold.m' }, ...
           { 'cofiCostFunc.m' }, ...
           { 'cofiCostFunc.m' }, ...
           { 'cofiCostFunc.m' }, ...
           { 'cofiCostFunc.m' }, ...
           };
end

function [correct out coransw] = check_single(partId)
  % Random Test Cases
  load 'results.mat'
  EPSILON_ERROR = 10^-5;
  n_u = 3; n_m = 4; n = 5;
  X = reshape(sin(1:n_m*n), n_m, n);
  Theta = reshape(cos(1:n_u*n), n_u, n);
  Y = reshape(sin(1:2:2*n_m*n_u), n_m, n_u);
  R = Y > 0.5;
  pval = [abs(Y(:)) ; 0.001; 1];
  yval = [R(:) ; 1; 0];
  params = [X(:); Theta(:)];
  if partId == 1
    [outa outb] = estimateGaussian(X);
    coransw = {out1a, out1b};
    out = {outa,outb};
    if abs(out1a - outa) < EPSILON_ERROR && abs(out1b - outb) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 2
    [outa outb] = selectThreshold(yval, pval);
    coransw = {out2a, out2b};  
    out = {outa,outb};
    if abs(out2a - outa) < EPSILON_ERROR && abs(out2b - outb) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 3
    [out]= cofiCostFunc(params, Y, R, n_u, n_m, ...
                       n, 0);
    coransw = out3;
    if abs(out3-out) < EPSILON_ERROR 
      correct = true;
    else
      correct = false;
    end
  elseif partId == 4
    [J out]= cofiCostFunc(params, Y, R, n_u, n_m, ...
                       n, 0);
    coransw = out4;
    if abs(out4-out) < EPSILON_ERROR 
      correct = true;
    else
      correct = false;
    end
  elseif partId == 5
    [out]= cofiCostFunc(params, Y, R, n_u, n_m, ...
                       n, 1.5);
    coransw = out5;
    if abs(out5-out) < EPSILON_ERROR 
      correct = true;
    else
      correct = false;
    end
 elseif partId == 6
    [J out]= cofiCostFunc(params, Y, R, n_u, n_m, ...
                       n, 1.5);
    coransw = out6;
    if abs(out6-out) < EPSILON_ERROR 
      correct = true;
    else
      correct = false;
    end
  end 
end



function partId = promptPart()
  fprintf('== Select which part(s) to submit:\n');
  partNames = validParts();
  srcFiles = sources();
  for i = 1:numel(partNames)
    fprintf('==   %d) %s [', i, partNames{i});
    fprintf(' %s ', srcFiles{i}{:});
    fprintf(']\n');
  end
  fprintf('==   %d) All of the above \n==\nEnter your choice [1-%d]: ', ...
          numel(partNames) + 1, numel(partNames) + 1);
  selPart = input('', 's');
  partId = str2num(selPart);
  if ~isValidPartId(partId)
    partId = -1;
  end
end

function ret = isValidPartId(partId)
  partNames = validParts();
  ret = (~isempty(partId)) && (partId >= 1) && (partId <= numel(partNames) + 1);
end

