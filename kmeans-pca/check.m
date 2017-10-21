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
  id = '7';
end

function [partNames] = validParts()
  partNames = { 
                'Find Closest Centroids (k-Means)', ...
                'Compute Centroid Means (k-Means)' ...
                'PCA', ...
                'Project Data (PCA)', ...
                'Recover Data (PCA)' ...
                };
end

function srcs = sources()
  % Separated by part
  srcs = { { 'findClosestCentroids.m' }, ...
           { 'computeCentroids.m' }, ...
           { 'pca.m' }, ...
           { 'projectData.m' }, ...
           { 'recoverData.m' } ...
           };
end

function [correct out coransw] = check_single(partId)
  % Random Test Cases
  load 'results.mat'
  EPSILON_ERROR = 10^-5;
   X = reshape(sin(1:165), 15, 11);
  Z = reshape(cos(1:121), 11, 11);
  C = Z(1:5, :);
  idx = (1 + mod(1:15, 3))';
  if partId == 1
    out =  findClosestCentroids(X, C);
    coransw = out1;
    if abs(out1 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 2
    out =  computeCentroids(X, idx, 3);
    coransw = out2;
    if abs(out2 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 3
    [outa, outb] = pca(X);
    coransw = {out3a, out3b};
    out = {outa,outb};
    if abs(out3a-outa) < EPSILON_ERROR && abs(out3b-outb) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 4
    out = projectData(X, Z, 5);
    coransw = out4;
    if abs(out4 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 5
    out = recoverData(X(:,1:5), Z, 5);
    coransw = out5;
    if abs(out5-out) < EPSILON_ERROR
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

