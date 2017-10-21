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
  id = '4';
end

function [partNames] = validParts()
  partNames = { 'Feedforward and Cost Function', ...
                'Regularized Cost Function', ...
                'Sigmoid Gradient', ...
                'Neural Network Gradient (Backpropagation)' ...
                'Regularized Gradient' ...
                };
end

function srcs = sources()
  % Separated by part
  srcs = { { 'nnCostFunction.m' }, ...
           { 'nnCostFunction.m' }, ...
           { 'sigmoidGradient.m' }, ...
           { 'nnCostFunction.m' }, ...
           { 'nnCostFunction.m' } };
end

function [correct out coransw] = check_single(partId)
  load 'results.mat'
EPSILON_ERROR = 10^-5;
  % Random Test Cases
  X = reshape(3 * sin(1:1:30), 3, 10);
  Xm = reshape(sin(1:32), 16, 2) / 5;
  ym = 1 + mod(1:16,4)';
  t1 = sin(reshape(1:2:24, 4, 3));
  t2 = cos(reshape(1:2:40, 4, 5));
  t  = [t1(:) ; t2(:)];

  if partId == 1
    out =  nnCostFunction(t, 2, 4, 4, Xm, ym, 0);
    coransw = out1;
    if abs(out1 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 2
    out =  nnCostFunction(t, 2, 4, 4, Xm, ym, 1.5);
    coransw = out2;
    if abs(out2 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 3
    out = sigmoidGradient(X);
    coransw = out3;
    if abs(out3 - out) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 4
    [outa outb] =  nnCostFunction(t, 2, 4, 4, Xm, ym, 0);
    coransw = {out4a out4b};
    out = {outa outb};
    if abs(out4a - outa) < EPSILON_ERROR && abs(out4b - outb) < EPSILON_ERROR
      correct = true;
    else
      correct = false;
    end
  elseif partId == 5
    [outa outb] =  nnCostFunction(t, 2, 4, 4, Xm, ym, 1.5);
    out = {outa outb};
    coransw = {out5a out5b};
    if abs(out5a - outa) < EPSILON_ERROR && abs(out5b - outb) < EPSILON_ERROR
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

