function [objDim, parDim, idealp, params, subproblems]=init(mop, gen, propertyArgIn, newpop)
%Set up the initial setting for the MOEA/D.
    objDim=mop.od;
    parDim=mop.pd;    
    idealp=ones(1,objDim)*inf;
    
    %the default values for the parameters.
   % params.popsize=200;params.niche=20;params.iteration=50;
    params.dmethod='te';
    params.F =[0.6,0.8,1.0];
    params.CR = [0.1,0.2,1.0];   
%     params.F =0.8;
%     params.CR = 0.2;
%     params.F =0.1;
%     params.CR = 1;    
    %handle the parameters, mainly about the popsize
    while length(propertyArgIn)>=2
        prop = propertyArgIn{1};
        val=propertyArgIn{2};
        propertyArgIn=propertyArgIn(3:end);

        switch prop
            case 'popsize'
                params.popsize=val;            
            case 'niche'
                params.niche=val;
            case 'iteration'
                params.iteration=val;
            case 'method'
                params.dmethod=val;
            case 'nt'
                params.nt=val;
            case 'taot'
                params.taot=val;
            otherwise
                warning('moea doesnot support the given parameters name');
        end
    end
    
    subproblems = init_weights(params.popsize, params.niche, objDim);
    params.popsize = length(subproblems);
    
    %initial the subproblem's initital state.
   if nargin==3
    %CostFunction = mop.func(x, t0);
    inds = randompoint(mop, params, gen);
    
   else
    indv = struct('parameter',[],'objective',[], 'constrain', []);
    inds = repmat(indv, 1, params.popsize);
    cellpoints = num2cell(newpop, 2);
    [inds.parameter] = cellpoints{:};
   end
    v=[];
    for i=1:params.popsize
         tem_ans=mop.func(params.taot,params.nt,gen,inds(i).parameter,60); 
         inds(i).objective = tem_ans.obj;
         v = [v;inds(i).objective];
         inds(i).constrain = getcon(mop,tem_ans.con);
         [subproblems(i).curpoint] = inds(i) ;
         if inds(i).constrain==0
            
             subproblems(i).feasiblepoint = struct('parameter', {}, 'objective', {});
             subproblems(i).feasiblepoint(1).parameter = inds(i).parameter ;
             subproblems(i).feasiblepoint(1).objective = inds(i).objective ;
         else
             subproblems(i).feasiblepoint = struct('parameter', {}, 'objective', {});  
         end
    end
    
    idealp = min(idealp, min(v));
    
    clear inds indcells;
end