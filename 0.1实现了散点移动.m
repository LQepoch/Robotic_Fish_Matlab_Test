% 定义鱼群数量和目标点的坐标
numFish = 10;
targetPoint = [50, 50]; % 修改目标点坐标

% 初始化鱼群位置和速度
positions = rand(numFish, 2) * 50; % 将初始位置随机分布在 [0, 100] 的范围内
velocities = zeros(numFish, 2);

% 设置模拟参数
maxSpeed = 0.1; % 最大速度
neighborDistance = 1; % 邻居距离设置为最小距离为1
centeringFactor = 0.01; % 中心化因子
avoidanceFactor = 0.1; % 规避因子
targetFactor = 0.1; % 目标吸引因子

% 迭代更新鱼群位置
numIterations = 100;
for iteration = 1:numIterations
    clf; % 清空图形窗口
    
    % 计算每条鱼与其他鱼之间的距离
    distances = pdist2(positions, positions);
    
    % 计算平均位置
    meanPosition = mean(positions);
    
    % 更新每条鱼的速度和位置
    for fish = 1:numFish
        % 获取当前鱼的邻居（距离小于等于邻居距离的鱼）
        neighbors = find(distances(fish, :) <= neighborDistance & distances(fish, :) > 0); % 确保排除自身
        
        % 计算规避和中心化向量
        avoidanceVector = sum(positions(fish, :) - positions(neighbors, :), 1);
        centeringVector = meanPosition - positions(fish, :);
        
        % 计算目标吸引向量
        targetVector = targetPoint - positions(fish, :);
        
        % 更新速度和位置
        velocities(fish, :) = velocities(fish, :) + ...
            avoidanceFactor * avoidanceVector + ...
            centeringFactor * centeringVector + ...
            targetFactor * targetVector;
        velocities(fish, :) = min(velocities(fish, :), maxSpeed); % 限制最大速度
        positions(fish, :) = positions(fish, :) + velocities(fish, :);
        
        % 绘制每条鱼的位置
        scatter(positions(:, 1), positions(:, 2), 'filled');
        hold on;
        plot(targetPoint(1), targetPoint(2), 'r*', 'MarkerSize', 10);
        xlim([0 110]); % 调整坐标范围以适应目标点
        ylim([0 110]);
        title('Fish Swarm Control');
    end
    
    drawnow; % 更新图形窗口
end

