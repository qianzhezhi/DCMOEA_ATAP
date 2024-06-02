function [fronts, ranks] = select_NDSort(population)
%SELECT_NDSORT 非支配排序
% population: the population to be sorted, each row represents an individual
% constraints: a matrix of constraint violations of the same size as population, where positive values indicate violations and negative or zero values indicate feasibility
% fronts: a cell array containing individuals in each front, with the first front being fronts{1}, the second front being fronts{2}, etc.
% ranks: an array indicating the front number of each individual

    n = size(population, 1); % number of individuals
    F = cell(1, n); % set of solutions that i dominates over
    S = zeros(1, n); % number of solutions that dominate i
%     N = zeros(1, n); % number of solutions that do not violate any constraint more severely than i
    fronts = cell(1, n); % individuals in each front
    ranks = Inf(1, n); % front number of each individual (initialized to infinity)
    
   
    for i = 1:n
        for j = 1:n
            if all(population(j,:) >= population(i,:)) && any(population(j,:) > population(i,:))
                F{i} = [F{i}, j];
            elseif all(population(i,:) >= population(j,:)) && any(population(i,:) > population(j,:)) 
                S(i) = S(i) + 1;
            end
        end
        if S(i) == 0 % i belongs to the first front
            ranks(i) = 1;
            fronts{1} = [fronts{1}, i];
        end
    end

    frontNum = 1; % current front number
    while ~isempty(fronts{frontNum})
        nextFront = []; % 存储下一层支配解
        for i = 1:length(fronts{frontNum})
            curr = fronts{frontNum}(i);
            for j = 1:length(F{curr})
                S(F{curr}(j)) = S(F{curr}(j)) - 1;
                if S(F{curr}(j)) == 0 % F{curr}(j) belongs to the next front
                    ranks(F{curr}(j)) = frontNum + 1;
                    nextFront = [nextFront, F{curr}(j)];
                end
            end     
        end
        frontNum = frontNum + 1;
        fronts{frontNum} = nextFront;
    end
    
end

