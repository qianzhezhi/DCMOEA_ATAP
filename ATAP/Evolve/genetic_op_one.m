function [ind,PP] = genetic_op_one(subproblems, index, domain, params, best_parameter)
%GENETIC_OP_ONE 此处显示有关此函数的摘要
%   此处显示详细说明


si = ones(1,4)*index;
si(1)=index;

delta = 0.1;
if rand < delta
    neighbourindex = subproblems(index).neighbour; 
    %The random draw from the neighbours.
    nsize = length(neighbourindex);
    PP = randperm(nsize);
    si(2)=neighbourindex(PP(1));       
    si(3)=neighbourindex(PP(2));
    si(4)=neighbourindex(PP(3));
else
    N=params.popsize;
    PP = randperm(N);
    si(2)=PP(1);
    si(3)=PP(2);
    si(4)=PP(3);
end
%retrieve the individuals.
points =[subproblems(si).curpoint];
selectpoints = vertcat(points.parameter);

oldpoint = subproblems(index).curpoint.parameter;
parDim = size(domain, 1);
jrandom = ceil(rand*parDim);

randomarray = rand(1,parDim);
deselect = randomarray<params.CR(1,randi(3));
deselect(jrandom)=true;

newpoint = selectpoints(2,:)+rand*(best_parameter-selectpoints(2,:))+params.F(1,randi(3))*(selectpoints(4,:)-selectpoints(3,:));


newpoint(~deselect)=oldpoint(~deselect);

%repair the new value.
newpoint=max(newpoint, domain(:,1)');
newpoint=min(newpoint, domain(:,2)');

ind = struct('parameter',newpoint,'objective',[], 'constrain',[]);
ind = polynomial_mutate(ind, domain(:,1)', domain(:,2)');
end

