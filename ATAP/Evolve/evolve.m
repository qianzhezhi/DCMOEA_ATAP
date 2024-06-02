function subproblems = evolve(gen, subproblems, mop, params,time, maxgen)
    global idealpoint;
    
    infeasible_count=0;      
    pop_feasible=[];
   
    %计算不可行解的数量
    for i=1:length(subproblems)
        point = subproblems(i).curpoint;
            if point.constrain~=0
                infeasible_count=infeasible_count+1;
            else
                pop_feasible=[pop_feasible point];
            end        
    end
    
    rf=infeasible_count*1.0/params.popsize;
    
    if infeasible_count<params.popsize
        population=vertcat(pop_feasible.objective);
        [ranks,~,~] = fastNonDominatedSort(population);
        front_one= find(ranks == 1);
        randnum=randi(length(front_one),1);
        best_parameter=pop_feasible(randnum).parameter;
    else
%         从种群中选cv最小的
        best_cv=inf;
        for i=1:length(subproblems)
            point = subproblems(i).curpoint;
            if point.constrain<best_cv
                best_parameter=point.parameter;
                best_cv=point.constrain;
            end      
        end
    
    end

     if (rf<=1/(0.9+exp(1)^(20*(time/maxgen-0.4))))
    
        stage=1;%表示阶段几，环境选择的时候要用
        
        for i=1:length(subproblems)
            %new point generation using genetic operations, and evaluate it.
            
            ind = genetic_op_one(subproblems, i, mop.domain, params,best_parameter);
           
            tem_ans=mop.func(params.taot,params.nt,gen,ind.parameter,60); 
            ind.objective = tem_ans.obj;
            ind.constrain = getcon(mop,tem_ans.con);

            idealpoint = min(idealpoint, ind.objective);
            %update the neighbours.
            neighbourindex = subproblems(i).neighbour;
            subproblems(neighbourindex) = update(subproblems(neighbourindex),ind, idealpoint,stage);
            %clear ind obj neighbourindex neighbours;        
            if ind.constrain==0
                if numel(subproblems(i).feasiblepoint)<35                   
                    subproblems(i).feasiblepoint(end+1).parameter = ind.parameter ;
                    subproblems(i).feasiblepoint(end).objective = ind.objective ;
                else
                    [max_fitness, max_idx] = max(subobjective(repmat([subproblems(i).weight], 1, size(vertcat(subproblems(i).feasiblepoint.objective),1)), vertcat(subproblems(i).feasiblepoint.objective),  idealpoint, params.dmethod));
                    if subobjective([subproblems(i).weight], ind.objective,  idealpoint, params.dmethod)<max_fitness
                        subproblems(i).feasiblepoint(max_idx).parameter=ind.parameter ;
                        subproblems(i).feasiblepoint(max_idx).objective=ind.objective ;
                    end
                end
            end
            %clear ind obj neighbourindex neighbours; 
            clear ind obj neighbourindex;
        end
        
    else
        stage=2;
        
        for i=1:length(subproblems)
           
            ind = genetic_op_two(subproblems, i, mop.domain, params);
                                        
            tem_ans=mop.func(params.taot,params.nt,gen,ind.parameter,60); 
            ind.objective = tem_ans.obj;
            ind.constrain = getcon(mop,tem_ans.con);

            idealpoint = min(idealpoint, ind.objective);
            
            %update the neighbours.
            neighbourindex = subproblems(i).neighbour;
            subproblems(neighbourindex) = update(subproblems(neighbourindex),ind, idealpoint,stage,rf,time,maxgen);                
            
            if ind.constrain==0              
                if numel(subproblems(i).feasiblepoint)<35                   
                    subproblems(i).feasiblepoint(end+1).parameter = ind.parameter ;
                    subproblems(i).feasiblepoint(end).objective = ind.objective ;
                else
                    [max_fitness, max_idx] = max(subobjective(repmat([subproblems(i).weight], 1, size(vertcat(subproblems(i).feasiblepoint.objective),1)), vertcat(subproblems(i).feasiblepoint.objective),  idealpoint, params.dmethod));
                    if subobjective([subproblems(i).weight], ind.objective,  idealpoint, params.dmethod)<max_fitness
                        subproblems(i).feasiblepoint(max_idx).parameter=ind.parameter ;
                        subproblems(i).feasiblepoint(max_idx).objective=ind.objective ;
                    end
                end
            end
            %clear ind obj neighbourindex neighbours; 
            clear ind obj neighbourindex;
        end
        
     end
     
end

function subp =update(subp, ind, idealpoint,stage)
    global params
    
    if (stage==1)%
        newobj=subobjective([subp.weight], ind.objective,  idealpoint, params.dmethod);
        oops = [subp.curpoint]; 
        oldobj=subobjective([subp.weight], vertcat(oops.objective), idealpoint, params.dmethod );
        C = newobj < oldobj;
        [subp(C).curpoint]= deal(ind);
       
    else
        newobj=subobjective([subp.weight], ind.objective,  idealpoint, params.dmethod);
        oops = [subp.curpoint]; 
        oldobj=subobjective([subp.weight], vertcat(oops.objective), idealpoint, params.dmethod );
        C = newobj < oldobj;
        %考虑约束
        for i=1:length(oops)
            if C(1,i)==1&&oops(i).constrain<ind.constrain
                C(1,i)=0;
            elseif C(1,i)==0&&oops(i).constrain>ind.constrain
                C(1,i)=1;
                
            end
        end
       
        [subp(C).curpoint]= deal(ind);               
    end
    clear C newobj oops oldobj;
end


