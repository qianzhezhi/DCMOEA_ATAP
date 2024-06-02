function crowdedDist = calculateCrowdingDistance(all_obj, ranks)
% INPUTS:
% all_obj: 所有个体的目标函数值，大小为 (N x M)，其中 N 是个体数，M 是目标函数数量。
% ranks: 所有个体的 Pareto 前沿等级，大小为 (N x 1)。

% OUTPUTS:
% crowdedDist: 拥挤距离，大小为 (N x 1)。

    num_objs = size(all_obj, 2); % 目标函数数量
    num_inds = length(ranks); % 个体数

    % 初始化拥挤距离为 0
    crowdedDist = zeros(num_inds, 1);

    for m = 1:num_objs
        [~, sorted_order] = sort(all_obj(:, m)); % 对第 m 个目标函数排序
        sorted_fronts = ranks(sorted_order); % 根据排序顺序重新排列 fronts

        % 第一个和最后一个个体的拥挤距离为无穷大（因为这两个个体没有其他个体可以与之共享空间）
        crowdedDist(sorted_order(1)) = Inf;
        crowdedDist(sorted_order(end)) = Inf;

        % 计算中间个体的拥挤距离
        for i = 2:num_inds-1
            if sorted_fronts(i) == sorted_fronts(i-1) && sorted_fronts(i) == sorted_fronts(i+1)
                % 如果个体前后都在同一 Pareto 前沿，则计算它们之间的距离
                crowdedDist(sorted_order(i)) = crowdedDist(sorted_order(i)) + ...
                    (all_obj(sorted_order(i+1), m) - all_obj(sorted_order(i-1), m))/...
                    (max(all_obj(:,m))-min(all_obj(:,m)));
            end
        end
    end

end
