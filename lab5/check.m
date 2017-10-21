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
  id = '1';
end

function [partNames] = validParts()
  partNames = { 'Sigmoid Function ', ...
                'Logistic Regression Cost', ...
                'Logistic Regression Gradient', ...
                'Predict', ...
                'Regularized Logistic Regression Cost' ...
                'Regularized Logistic Regression Gradient' ...
                };
end

function srcs = sources()
  % Separated by part
  srcs = { { 'sigmoid.m' }, ...
           { 'costFunction.m' }, ...
           { 'costFunction.m' }, ...
           { 'predict.m' }, ...
           { 'costFunctionReg.m' }, ...
           { 'costFunctionReg.m' } };
end


function [correct out coransw] = check_single(partId)
  % Random Test Cases
  load 'results.mat'
  EPSILON_ERROR = 10^-5;
  X = [ones(20,1) (exp(1) * sin(1:1:20))' (exp(0.5) * cos(1:1:20))'];
  y = sin(X(:,1) + X(:,2)) > 0;

  if partId == 1
    out =  sigmoid(X);
    coransw = out1;
    if abs(out1 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 2
    [out tmp] =  costFunction([0.25 0.5 -0.5]', X, y);
    coransw = out2;
    if abs(out2 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 3
    [tmp, out] = costFunction([0.25 0.5 -0.5]', X, y);
    coransw = out3;
    if abs(out3 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 4
    out =  predict([0.25 0.5 -0.5]', X);
    coransw = out4;
    if abs(out4 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 5
    [out, tmp] = costFunctionReg([0.25 0.5 -0.5]', X, y, 0.1);
    coransw = out5;
    if abs(out5 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 6
    [tmp, out] = costFunctionReg([0.25 0.5 -0.5]', X, y, 0.1);
    coransw = out6;
    if abs(out6 - out) < EPSILON_ERROR
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

