function subp=init_weights(popsize, niche, objDim)
% init_weights function initialize a pupulation of subproblems structure
% with the generated decomposition weight and the neighbourhood
% relationship.                     %%��ʼȨ�غ��������ɵķֽ�Ȩ�������ϵ��ʼ��������ṹ��һ���涨�� 
    subp=[];
%         if objDim==0
%             for i=0:popsize
%                 p=struct('weight',[],'neighbour',[],'optimal',Inf,'optpoint',[],'optCV',[],'curpoint',[]);
%                 weight=zeros(2,1);
%                 weight(1)=i/popsize;
%                 weight(2)=(popsize-i)/popsize;
%                 p.weight=weight;
%                 subp=[subp p];
%             end
%           else
%�������weight���������Ǹ�ֵ��subproblem�����weight
            [weight] = UniformPoint(popsize,objDim);   %%%����UniformPoint  134��3
            %plot3(weight(:,1),weight(:,2),weight(:,3),'b.');
            for i = 0 : length(weight)-1 %popsize        %%%��uniformpoint������weightֵһ��һ���ļ��ص�subp
                 p=struct('weight',[],'neighbour',[],'optimal',Inf,'optpoint',[],'optCV',[],'curpoint',[],'feasiblepoint',[]);
                 pt=weight(i+1,:);
                 p.weight = pt';
                 subp=[subp p];
            end
%         end

    %Set up the neighbourhood.
    leng=length(subp);
 
    for i = 1 : leng  %%��1��leng��1��120�飩Ȩ���ٸ���W
       WT = subp(i).weight;
       W(i,:) = WT';
    end
    B = pdist2(W,W);%%����n*n�ľ������pdist������������֮��ľ������   �������B��һ�����ҶԳƵĶԽǾ���
    [~,B] = sort(B,2); 
    for i = 1 : leng
      subp(i).neighbour = B(i,1:niche);
    end
   
end