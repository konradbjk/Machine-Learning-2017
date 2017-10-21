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
  partNames = { 'Regularized Linear Regression Cost Function', ...
                'Regularized Linear Regression Gradient', ...
                'Learning Curve', ...
                'Polynomial Feature Mapping' ...
                'Validation Curve' ...
                };
end

function srcs = sources()
  % Separated by part
  srcs = { { 'linearRegCostFunction.m' }, ...
           { 'linearRegCostFunction.m' }, ...
           { 'learningCurve.m' }, ...
           { 'polyFeatures.m' }, ...
           { 'validationCurve.m' } };
end

function [correct out coransw] = check_single(partId)
  % Random Test Cases
  load 'results.mat'
  EPSILON_ERROR = 10^-5;
  X = [ones(10,1) sin(1:1.5:15)' cos(1:1.5:15)'];
  y = sin(1:3:30)';
  Xval = [ones(10,1) sin(0:1.5:14)' cos(0:1.5:14)'];
  yval = sin(1:10)';
  if partId == 1
    out = linearRegCostFunction(X, y, [0.1 0.2 0.3]', 0.5);
    coransw = out1;
    if abs(out1 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 2
    [J, out] = linearRegCostFunction(X, y, [0.1 0.2 0.3]', 0.5);
    coransw = out2;
    if abs(out2 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 3
    [outa, outb] =  ...
        learningCurve(X, y, Xval, yval, 1);
    coransw = {out3a, out3b};
    out = {outa,outb};
    if abs(out3a-outa) < EPSILON_ERROR && abs(out3b-outb) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 4
    [out] = polyFeatures(X(2,:)', 8);
    coransw = out4;
    if abs(out4-out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 5
    [outa, outb, outc] = ...
        validationCurve(X, y, Xval, yval);
    coransw = {out5a out5b out5c};
    if abs(out5a-outa) < EPSILON_ERROR && abs(out5b-outb) < EPSILON_ERROR && abs(out5c-outc) < EPSILON_ERROR
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

