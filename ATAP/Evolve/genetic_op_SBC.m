function ind = genetic_op_SBC(subproblems, index, domain, params)
    K=randsample(params.niche,2);
    j1=subproblems(index).neighbour(K(1));
    p1=subproblems(j1).curpoint;
    Parent1=p1.parameter;
    [N,D] = size(Parent1);
    
    j2=subproblems(index).neighbour(K(2));
    p2=subproblems(j2).curpoint;
    Parent2=p2.parameter;
    
    [proC,disC,proM,disM] = deal(0.8,20,1,20);
    Lower = domain(:,1)';
    Upper = domain(:,2)';
    
    % Simulated binary crossover
    beta = zeros(N,D);
    mu   = rand(N,D);
    beta(mu<=0.5) = (2*mu(mu<=0.5)).^(1/(disC+1));
    beta(mu>0.5)  = (2-2*mu(mu>0.5)).^(-1/(disC+1));
    beta = beta.*(-1).^randi([0,1],N,D);
    beta(rand(N,D)<0.5) = 1;
    beta(repmat(rand(N,1)>proC,1,D)) = 1;
    Offspring = (Parent1+Parent2)/2+beta.*(Parent1-Parent2)/2;

    % Polynomial mutation
    Site  = rand(N,D) < proM/D;
    mu    = rand(N,D);
    temp  = Site & mu<=0.5;
    Offspring       = min(max(Offspring,Lower),Upper);
    Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                        (1-(Offspring(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
    temp = Site & mu>0.5; 
    Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                        (1-(Upper(temp)-Offspring(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));

     for i=1:D
         Offspring(i) = min(max(Offspring(i),Lower(i)), Upper(i));
     end         

    ind = struct('parameter',Offspring,'objective',[], 'constrain',[]);
    

end

