
```matlab
% 设置无人机数量和初始位置
droneCount = 8;
drones = randi([50, 450], droneCount, 2);

% 定义目标V字型队列
vFormation = [
    [250, 100];
    [200, 200];
    [300, 200];
    [150, 300];
    [350, 300];
    [100, 400];
    [400, 400];
    [250, 500];
];

% 慢慢移动无人机至V字型队列
speed = 2;  % 调整速度以控制移动过程的速度

figure;
while true
    % 绘制当前无人机群的状态
    clf;
    scatter(drones(:, 1), drones(:, 2), 'filled', 'r');
    xlim([0 500]);
    ylim([0 500]);
    pause(0.01);

    % 计算每个无人机的移动向量
    for i = 1:droneCount
        targetPos = vFormation(i, :);

        % 更新无人机位置
        currentPos = drones(i, :);
        dx = targetPos(1) - currentPos(1);
        dy = targetPos(2) - currentPos(2);
        distance = sqrt(dx * dx + dy * dy);

        if distance > speed
            ratio = speed / distance;
            drones(i, 1) = currentPos(1) + dx * ratio;
            drones(i, 2) = currentPos(2) + dy * ratio;
        else
            drones(i, :) = targetPos;
        end
    end
end
```
![image](https://github.com/LQepoch/Robotic_Fish_Matlab_Test/assets/43512109/185b7393-054a-4402-9db5-8c91e36e97e1)

![image](https://github.com/LQepoch/Robotic_Fish_Matlab_Test/assets/43512109/a0ca8062-3f26-440d-a803-67618fcae788)
