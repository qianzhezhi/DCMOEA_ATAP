function [W] = UniformPoint(N,M)   %%%[weight] = UniformPoint(134,3); %%%�ļ����þ����ڵ�λ��ƽ���ϲ���3Ŀ��ľ��ȷֲ��ĵ㣨Ȩ��������
%UniformPoint - Generate a set of uniformly distributed points on the unit
%hyperplane
%
%   [W,N] = UniformPoint(N,M) returns approximate N uniformly distributed
%   points with M objectives.
%
%   Example:
%       [W,N] = UniformPoint(275,10)

%--------------------------------------------------------------------------
% The copyright of the PlatEMO belongs to the BIMK Group. You are free to
% use the PlatEMO for research purposes. All publications which use this
% platform or any code in the platform should acknowledge the use of
% "PlatEMO" and reference "Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu
% Jin, PlatEMO: A MATLAB Platform for Evolutionary Multi-Objective
% Optimization, 2016".
%--------------------------------------------------------------------------

% Copyright (c) 2016-2017 BIMK Group

H1 = 1;
while nchoosek(H1+M,M-1) <= N
    H1 = H1 + 1;  %%%H1Ϊ14
end
W = nchoosek(1:H1+M-1,M-1) - repmat(0:M-2,nchoosek(H1+M-1,M-1),1) - 1;
%C = nchoosek(n,k) ����n��k�ǷǸ�����, ���� n!/((n�Ck)! k!).
%���Ǵ�n�������һ��ȡ��k�ֵ���ϵ�������
%���磺����nchoosek(2:2:10,4) ���ؽ��Ϊ��2��10��ż����ÿ��ȡ4����������ϣ�
%      2     4     6     8
%      2     4     6    10
%      2     4     8    10
%      2     6     8    10
%      4     6     8    10
% B=repmat( [1 2;3 4],2,3) ��[1 2;3 4]���������ظ�д2��3��
% B =
% 1      2      1     2    1    2
% 3      4      3     4    3    4
% 1      2      1     2    1     2
% 3      4      3     4    3     4
W = ([W,zeros(size(W,1),1)+H1]-[zeros(size(W,1),1),W])/H1;
if H1 < M
    H2 = 0;
    while nchoosek(H1+M-1,M-1)+nchoosek(H2+M,M-1) <= N
        H2 = H2 + 1;
    end
    if H2 > 0
        W2 = nchoosek(1:H2+M-1,M-1) - repmat(0:M-2,nchoosek(H2+M-1,M-1),1) - 1;
        W2 = ([W2,zeros(size(W2,1),1)+H2]-[zeros(size(W2,1),1),W2])/H2;
        W  = [W;W2/2+1/(2*M)];
    end
end
W = max(W,1e-6);
N = size(W,1);
end