
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

```c++
#include <iostream>
#include <opencv2/opencv.hpp>
#include <vector>

using namespace std;
using namespace cv;

// 绘制无人机群的当前状态
void drawDrones(Mat& frame, vector<Point>& drones) {
    for (const auto& point : drones) {
        circle(frame, point, 5, Scalar(0, 0, 255), -1);
    }
}

int main() {
    // 创建一个窗口用于显示结果
    namedWindow("Formation", WINDOW_NORMAL);

    // 设置无人机数量和初始位置
    int droneCount = 8;
    vector<Point> drones(droneCount);
    for (int i = 0; i < droneCount; i++) {
        drones[i] = Point(rand() % 400 + 50, rand() % 400 + 50);
    }

    // 定义目标V字型队列的顶点
    vector<Point> vFormation = {
        Point(250, 100),
        Point(200, 200),
        Point(300, 200),
        Point(150, 300),
        Point(350, 300),
        Point(100, 400),
        Point(400, 400),
        Point(250, 500)
    };

    // 慢慢移动无人机至V字型队列
    double speed = 2.0;  // 调整速度以控制移动过程的速度
    while (true) {
        Mat frame(500, 500, CV_8UC3, Scalar(255, 255, 255));

        // 绘制当前无人机群的状态
        drawDrones(frame, drones);

        // 计算每个无人机的移动向量
        for (int i = 0; i < droneCount; i++) {
            Point targetPos = vFormation[i];

            // 更新无人机位置
            Point& currentPos = drones[i];
            double dx = targetPos.x - currentPos.x;
            double dy = targetPos.y - currentPos.y;
            double distance = sqrt(dx * dx + dy * dy);

            if (distance > speed) {
                double ratio = speed / distance;
                currentPos.x += static_cast<int>(dx * ratio);
                currentPos.y += static_cast<int>(dy * ratio);
            }
            else {
                currentPos = targetPos;
            }
        }

        // 显示图像并等待按键退出
        imshow("Formation", frame);
        char key = waitKey(30);
        if (key == 27) {  // 按下ESC键退出
            break;
        }
    }

    return 0;
}

```
![image](https://github.com/LQepoch/Robotic_Fish_Matlab_Test/assets/43512109/185b7393-054a-4402-9db5-8c91e36e97e1)

![image](https://github.com/LQepoch/Robotic_Fish_Matlab_Test/assets/43512109/a0ca8062-3f26-440d-a803-67618fcae788)
