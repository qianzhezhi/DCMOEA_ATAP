function parent_fitness = P_fitness(P)
%P_FITNESS 
    %����һ�¿�����rf,%����f_ba
    num_f=0;%���н������
    pop_size=length(P);%��Ⱥ����
    
    for i = 1:pop_size
        
        if P(i).constrain == 0
            num_f = num_f + 1;
        end
        
    end
    rf=num_f*1.0/pop_size;   
    %����v
    v=vertcat(P.constrain);
    f_ba=vertcat(P.objective);
    num_obj=size(f_ba,2);
    distance=P_distance(rf,pop_size,num_obj,v,f_ba);
    penalty=P_penalty(rf,pop_size,num_obj,v,f_ba);
    parent_fitness=distance+penalty;
end

function dis=P_distance(rf,pop_size,num_obj,v,f_ba)
%distance����
    if rf==0
        for i=1:num_obj
            for j=1:pop_size
                dis(j,i)=v(j,:);
            end
        end
    else
        for i=1:num_obj
            for j=1:pop_size
                dis(j,i)=(f_ba(j,i)^2+v(j,:)^2)^0.5;
            end
        end
    end
end

function pen=P_penalty(rf,pop_size,num_obj,v,f_ba)
%P_PENALTY ����
    
    for i=1:num_obj
        for j=1:pop_size
            if rf==0
                x=0;
            else
                x=v(j,:);
            end
            if v(j,:)==0
                y=0;
            else
                y=f_ba(j,i);
            end
            pen(j,i)=(1-rf)*x+rf*y;
        end
    end
end
