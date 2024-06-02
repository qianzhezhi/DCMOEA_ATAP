function res=ATAP(mop,popSize,T_parameter,group)
%%初始化过程
    nt = T_parameter(group,1);
    taot = T_parameter(group,2);
    iteration=T_parameter(group,3);
    cnt = 1/nt;
    paramIn = {'popsize', popSize, 'niche', 5, 'iteration', iteration, 'method', 'te','nt',nt,'taot',taot};
    lower=mop.domain(:,1);
    upper=mop.domain(:,2);
    %global variable definition.
    global params idealpoint objDim parDim;
    
    gen=0;%进化的代数
    current_time = 0;
    T=1;
    T0 =60;
    [objDim, parDim, idealpoint, params, subproblems]=init(mop, gen, paramIn);
    
        
    while ~terminate(gen)

      if gen < T0
          t = 0;
      else
          t = cnt*(floor((gen-T0)/taot)+1); 
      end
       
%%动态处理过程         
        if t~= current_time

             pareto = [subproblems.feasiblepoint]; 
             POF=[];POS=[];
             for i=1:size(pareto,2)
                 if ~isempty(pareto(i).objective)
                    POF=[POF;pareto(i).objective];
                    POS=[POS;pareto(i).parameter];
                 end
             end

             [ranks,~,~] = fastNonDominatedSort(POF);
              POF_total = POF(ranks == 1,:);
              POS_total = POS(ranks == 1,:);
              if size(POF_total,1)>popSize
                 crowdedDist = calculateCrowdingDistance(POF_total, ones(size(POF_total,1),1));
                   [~,idx] = sort(crowdedDist, 'descend');
                   selectedSols = idx(1:params.popsize);
                   res{T}.POS_iter=POS_total(selectedSols,:);
                   res{T}.POF_iter=POF_total(selectedSols,:);
              else
                   res{T}.POS_iter=POS_total;
                   res{T}.POF_iter=POF_total;
              end
             res{T}.turePOF = getBenchmarkPOF(mop.Name,group,T,T_parameter);
             T=T+1;
            % DDA
             if T<3
                 newpop = initialize_variables(params.popsize, mop.pd,lower,upper);
			 else
			
			 POS_t1=res{T-1}.POS_iter;
			 POS_t2=res{T-2}.POS_iter;
			 newpop1 = AE_prediction(POS_t1, POS_t2,params.popsize,mop,t,params);
                 if (params.popsize-size(newpop1))>0
                     tempop=initialize_variables(params.popsize-size(newpop1), mop.pd,lower,upper);
                     newpop=[newpop1;tempop];
                 end
             end
             
             [objDim, parDim, idealpoint, params, subproblems]=init(mop, gen, paramIn, newpop);
             current_time = t;
        end
        if t==0
            time=gen;
            maxgen=T0;
        else
            time=gen-T0-params.taot*(T-2);
            maxgen=params.taot;
        end
        subproblems = evolve(gen, subproblems, mop, params, time, maxgen);
        %统计不可行解的数量
        count = 0;
        pareto = [subproblems.curpoint];
        for i = 1:length(pareto)
            if pareto(i).constrain~= 0
                count = count + 1;
            end
        end
         fprintf('iteration %u finished---infeasible count:%d\n', gen,count);
         gen = gen+1;

      
        %           disp(sprintf('total time used %u', etime(clock, starttime)));                           
    end  


end

