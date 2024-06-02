function [init_solution] = AE_prediction(curr_NDS, his_NDS, NP, Problem, gen,params)

% Prediction via Denoising Autoencoding in AE-MOEA for solving DMOP.

% curr_NDS and his_NDS denote N_l number of non-dominated solutions obtained in the current and previous time windows, respectively. 
% Both in the form of N_l*d matrix. 
% N_l is the number of individual, d is the variable dimension of the given DMOP, and NP denotes the population size of the evolutionary solver. 

% curr_POS is the POS solutions from current time window (the obtained non-dominated solution set). 

% output is the predicted initial solutions of the evolutionary search for new time window.
m = Problem.od;
N_curr = size(curr_NDS',2);
N_his = size(his_NDS',2);
[d, ~] = size(curr_NDS');
N_l = min(N_curr,N_his);

Fronts_his = ones(1,N_his);
Objectives_his = zeros(N_his,m);
for i=1:N_his    
    temans=Problem.func(params.taot,params.nt,gen,his_NDS(i,:),60);
    Objectives_his(i,:) =temans.obj;
end
Distances_his = CrowdDistances(Objectives_his, Fronts_his);
[~, index_his] = sort(Distances_his,'ascend'); 
his2_NDS = zeros(N_l,d);
for i=1:N_l
    his2_NDS(i,:) = his_NDS(index_his(i),:);
end
his_NDS = his2_NDS;

Fronts_curr = ones(1,N_curr);
Objectives_curr = zeros(N_curr,m);
for i=1:N_curr
    temans=Problem.func(params.taot,params.nt,gen,curr_NDS(i,:),60);
    Objectives_his(i,:) =temans.obj;
end
Distances_curr = CrowdDistances(Objectives_curr, Fronts_curr);
[~, index_curr] = sort(Distances_curr,'ascend');
curr2_NDS = zeros(N_l,d);
for i=1:N_l
    curr2_NDS(i,:) = curr_NDS(index_curr(i),:);
end 
curr_NDS = curr2_NDS;

curr_POS = curr_NDS;

Q = his_NDS*his_NDS';
P = curr_NDS*his_NDS';

lambda = 1e-5;
reg = lambda*eye(N_l);
reg(end,end) = 0;
M = P/(Q+reg);% the learned matrix M.

varM = M*his_NDS;
for i=1:N_l
    for j=1:d
        var(i,j) = (curr_NDS(i,j)-varM(i,j)).^2;
    end
end
v = mean2(var);

pre_solution = M*curr_POS+v;
curr_len = size(pre_solution, 1);
% if curr_len > NP/1.5
%     init_solution = pre_solution(1:NP/1.5,:);
% else 
%     init_solution = pre_solution;
% end
init_solution = pre_solution;

N_init=size(init_solution,1);

selected_rows1 = randperm(size(curr_NDS,1),N_init); 
DE_curr_NDS=curr_NDS(selected_rows1, :);

selected_rows2 = randperm(size(his_NDS,1), N_init); 
DE_his_NDS=his_NDS(selected_rows2, :);

init_solution=(init_solution)+rand*(init_solution-DE_curr_NDS)+rand*(DE_curr_NDS-DE_his_NDS);


left = NP-size(init_solution,1);
Len = min(left, size(curr_NDS,1));
for i=1:Len
   init_solution = [init_solution; curr_NDS(i,:)]; 
end

init_solution = init_solution';

VarMin=Problem.domain(:,1);
VarMax=Problem.domain(:,2);
for j=1:size(init_solution,2)
    for i=1:d
        init_solution(i,j) = min(max(init_solution(i,j),VarMin(i)), VarMax(i));
    end
end
init_solution = init_solution';
end