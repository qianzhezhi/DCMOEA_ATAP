function ind = randompoint(mop, params, gen)
%RANDOMNEW to generate n new point randomly from the mop problem given.
n=params.popsize;
if (nargin==1)
    n=1;
end

flag = 1;%保证初始化的结果至少有一个可行解
while flag
    randarray = rand(n,mop.pd);
    lowend = mop.domain(:,1);
    span = mop.domain(:,2)-lowend;
    lowend=lowend';
    span=span';
    point = randarray.*(span(ones(1, n),:))+ lowend(ones(1,n),:);
    cellpoints = num2cell(point, 2);
    tem_ans=mop.func(params.taot,params.nt,gen,point,60);
    for i = 1:numel(tem_ans)
            tem_con = getcon(mop,tem_ans(i).con);
            if tem_con==0
                flag = 0;
                break;
            end
     end
    
end

indiv = struct('parameter',[],'objective',[], 'constrain', []);
ind = repmat(indiv, 1, n);
[ind.parameter] = cellpoints{:};

% estimation = struct('obj', NaN ,'std', NaN);
% [ind.estimation] = deal(repmat(estimation, prob.od, 1));
end
