%Omid55
function [ population ] = CreateTrialVectorAndCrossOver( population,fitnesses,Beta,Pr,Nv , sp,lx )

%disp('Create Trial Vector And Doing CrossOver ... ');
len = size(population,1);
nextGeneration = [];
for i=1:len
    
    Xi = population(i,:);
    fXi = fitnesses(i,:);
    
    diffs = zeros(1,size(population,2));
    list = 1:size(population,1);
    list(i) = [];
    for j=1:Nv
        selected = GetDistinctItems(list,2);
        xs = population(selected,:);
        diffs = diffs + xs(1,:) - xs(2,:);
        list(list == selected(1)) = [];
        list(list == selected(2)) = [];
    end
    x_selected = population(GetDistinctItems(list,1),:);
    Ui = x_selected + Beta * diffs;
    
    % Binomial Crossover
    genesNum = size(population,2);
    jStar = randi(genesNum,1);
    J = jStar;
    for j=1:genesNum
        if rand() < Pr && j~=jStar
            J = [J j];
        end
    end
    
    child = Xi;
    child(J) = Ui(J);
    
   % now we must make child valid
%     % 1-
%     child = child / max(abs(child));
    
    % 2-
    if ~isempty(find(child>1, 1))
        child(child>1) = 1;
    end
    if ~isempty(find(child<-1, 1))
        child(child<-1) = -1;
    end
    child = child * 1;
    
    if ~exist('lx','var')
        childFitness = ObjectiveFunction(child,sp);
    else
        childFitness = ObjectiveFunction(child,sp,lx);
    end
    if childFitness >= fXi
        nextGeneration = [nextGeneration; child];
    else
        nextGeneration = [nextGeneration; Xi];
    end

end

population = nextGeneration;


end
