function [ind,PP] = genetic_op_two(subproblems, index, domain, params)
%GENETIC_OP_ONE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


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

newpoint = selectpoints(1,:)+rand*(selectpoints(2,:)-selectpoints(1,:))+params.F(1,randi(3))*(selectpoints(4,:)-selectpoints(3,:));


newpoint(~deselect)=oldpoint(~deselect);

%repair the new value.
newpoint=max(newpoint, domain(:,1)');
newpoint=min(newpoint, domain(:,2)');

ind = struct('parameter',newpoint,'objective',[], 'constrain',[]);
ind = polynomial_mutate(ind, domain(:,1)', domain(:,2)');
end

