function crowdedDist = calculateCrowdingDistance(all_obj, ranks)
% INPUTS:
% all_obj: ���и����Ŀ�꺯��ֵ����СΪ (N x M)������ N �Ǹ�������M ��Ŀ�꺯��������
% ranks: ���и���� Pareto ǰ�صȼ�����СΪ (N x 1)��

% OUTPUTS:
% crowdedDist: ӵ�����룬��СΪ (N x 1)��

    num_objs = size(all_obj, 2); % Ŀ�꺯������
    num_inds = length(ranks); % ������

    % ��ʼ��ӵ������Ϊ 0
    crowdedDist = zeros(num_inds, 1);

    for m = 1:num_objs
        [~, sorted_order] = sort(all_obj(:, m)); % �Ե� m ��Ŀ�꺯������
        sorted_fronts = ranks(sorted_order); % ��������˳���������� fronts

        % ��һ�������һ�������ӵ������Ϊ�������Ϊ����������û���������������֮����ռ䣩
        crowdedDist(sorted_order(1)) = Inf;
        crowdedDist(sorted_order(end)) = Inf;

        % �����м�����ӵ������
        for i = 2:num_inds-1
            if sorted_fronts(i) == sorted_fronts(i-1) && sorted_fronts(i) == sorted_fronts(i+1)
                % �������ǰ����ͬһ Pareto ǰ�أ����������֮��ľ���
                crowdedDist(sorted_order(i)) = crowdedDist(sorted_order(i)) + ...
                    (all_obj(sorted_order(i+1), m) - all_obj(sorted_order(i-1), m))/...
                    (max(all_obj(:,m))-min(all_obj(:,m)));
            end
        end
    end

end
