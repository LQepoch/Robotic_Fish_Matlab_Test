% 设定箱子的尺寸和起始、目标位置
box_length = 10; % 箱子长度
box_width = 10; % 箱子宽度
box_height = 10; % 箱子高度
start_pos = [1 1 1]; % 起始位置为(1, 1, 1)
target_pos = [8 7 5]; % 目标位置为(8, 7, 5)

% 设定机器鱼数量和迭代次数
num_fish = 5;
num_iterations = 100;

% 初始化机器鱼位置和速度
positions = repmat(start_pos, num_fish, 1);
velocities = zeros(num_fish, 3);

% 初始化轨迹变量
trajectory = zeros(num_fish, num_iterations, 3);

% 添加障碍物
num_obstacles = 10;
min_obstacle_size = [1 1 1];
max_obstacle_size = [3 3 3];
obstacle_positions = rand(num_obstacles, 3) .* repmat([box_length box_width box_height], num_obstacles, 1);
obstacle_sizes = min_obstacle_size + rand(num_obstacles, 3) .* (max_obstacle_size - min_obstacle_size);

% 循环迭代计算机器鱼位置
for iteration = 1:num_iterations
    % 计算机器鱼之间的相对位置和距离
    relative_positions = positions - repmat(mean(positions), num_fish, 1);
    distances = vecnorm(relative_positions, 2, 2);
    
    % 计算机器鱼的速度更新
    for fish = 1:num_fish
        % 集体行为：引导机器鱼向目标位置移动
        velocities(fish, :) = velocities(fish, :) + (target_pos - positions(fish, :)) / 10;
        
        % 排斥行为：避免机器鱼之间的碰撞
        repulsion_force = sum(relative_positions ./ (distances.^2), 1);
        velocities(fish, :) = velocities(fish, :) - repulsion_force;
        
        % 对速度进行限制，防止过快移动
        max_speed = 0.5;
        velocities(fish, :) = min(velocities(fish, :), max_speed);
    end
    
    % 更新机器鱼位置
    positions = positions + velocities;
    
    % 边界检查
    positions = max(positions, [0 0 0]);
    positions = min(positions, [box_length box_width box_height]);
    
    % 碰撞检测
    for fish = 1:num_fish
        for obstacle = 1:num_obstacles
            if all(positions(fish, :) >= obstacle_positions(obstacle, :)) && ...
                    all(positions(fish, :) <= obstacle_positions(obstacle, :) + obstacle_sizes(obstacle, :))
                % 如果机器鱼与障碍物发生碰撞，则反向移动
                velocities(fish, :) = -velocities(fish, :);
            end
        end
    end
    
    % 将机器鱼位置保存到轨迹变量中
    trajectory(:, iteration, :) = positions;
end

% 绘制机器鱼轨迹图和障碍物
figure;
hold on;
% 清除之前的图形
clf;

% 绘制水族箱边界
box_vertices = [
    0 0 0;              % 底面四个顶点
    box_length 0 0;
    box_length box_width 0;
    0 box_width 0;
    0 0 box_height;     % 顶面四个顶点
    box_length 0 box_height;
    box_length box_width box_height;
    0 box_width box_height
];
box_faces = [
    1 2 3 4;            % 底面
    5 6 7 8;            % 顶面
    1 2 6 5;            % 四个竖立面
    2 3 7 6;
    3 4 8 7;
    4 1 5 8
];
patch('Faces', box_faces, 'Vertices', box_vertices, 'FaceColor', 'none', 'EdgeColor', 'k');

% 绘制障碍物
for obstacle = 1:num_obstacles
    obstacle_pos = obstacle_positions(obstacle, :);
    obstacle_size = obstacle_sizes(obstacle, :);
    
    % 障碍物边界顶点坐标
    obstacle_vertices = [
        obstacle_pos;                                      % 左下角
        obstacle_pos + [obstacle_size(1) 0 0];             % 右下角
        obstacle_pos + [obstacle_size(1) obstacle_size(2) 0];      % 右上角
        obstacle_pos + [0 obstacle_size(2) 0];             % 左上角
        obstacle_pos + [0 0 obstacle_size(3)];             % 左下角的顶面
        obstacle_pos + [obstacle_size(1) 0 obstacle_size(3)];    % 右下角的顶面
        obstacle_pos + [obstacle_size(1) obstacle_size(2) obstacle_size(3)];    % 右上角的顶面
        obstacle_pos + [0 obstacle_size(2) obstacle_size(3)]     % 左上角的顶面
    ];
    
    % 障碍物边界面
    obstacle_faces = [
        1 2 3 4;            % 底面
        5 6 7 8;            % 顶面
        1 2 6 5;            % 四个竖立面
        2 3 7 6;
        3 4 8 7;
        4 1 5 8
    ];
    
    patch('Faces', obstacle_faces, 'Vertices', obstacle_vertices, 'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.3);
end

% 绘制机器鱼轨迹
for fish = 1:num_fish
    x = squeeze(trajectory(fish, :, 1));
    y = squeeze(trajectory(fish, :, 2));
    z = squeeze(trajectory(fish, :, 3));
    plot3(x, y, z, 'b');
    scatter3(x(1), y(1), z(1), 'filled', 'g'); % 起始位置用绿色实心点表示
    scatter3(x(end), y(end), z(end), 'filled', 'r'); % 目标位置用红色实心点表示
end

% 设置坐标轴范围
axis([0 box_length 0 box_width 0 box_height]);
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
