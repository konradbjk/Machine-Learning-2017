A = 1;
B = 2;
C = 3;
D = 4;
E = 5;

Elements = [A; B; C; D; E];

Transactions = { 
  [A C D];
  [B C E];
  [A B C E];
  [B E];
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%number of itemsets to generate, and minimal confidence and support
k = 3;
support = 0.5;
confidence = 0.6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%it gets itemset and generates k itemset based on it
function Kitemset = generateKitemset(K,Itemset, Transactions)
  Karray = 1:K;
  Kset = unique(sort (perms (Itemset)(:,Karray), 2), 'rows');
  Kitemset = {Kset, zeros(length(Kset),1)};
  for i = 1:length(Kset)
     Kitemset{1,2}(i) = countSupport(Kitemset{1,1}(i,:),Transactions);
  end
end

function frequent = eliminateUnfrequent(Kitemset, SupportBoundary)
  frequent = {};
  element = 1;
  for i=1:length(Kitemset{1,1})
    if Kitemset{1,2}(i) >= SupportBoundary
       frequent{1,1}(element,:) = Kitemset{1,1}(i,:);
       frequent{1,2}(element,:) = Kitemset{1,2}(i,:);
       element = element+1; 
    end
  end

end

%it counts a support of a itemset given as a parameter
function supportCount = countSupport(Itemset, Transactions)
    count = 0;
    for j = 1:length(Transactions)
      result = intersect(Itemset,Transactions{j});
      if(length(result) == length(Itemset))
        count = count +1;
      end
    end
    supportCount = count;

end

function FrequentKitemsets = apriori(A, B)
  k=3;
  support = 0.5;
  FrequentKitemsets = generateKitemset(1,A,B);
  FrequentKitemsets = eliminateUnfrequent(A,B);
  for i=2:k
    FrequentKitemsets = generateKitemset(i,FrequentKitemsets(1,1),Transactions);
    FrequentKitemsets = eliminateUnfrequent(FrequentKitemsets,support);
   end
end