```matlab
#include <iostream>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

// 绘制无人机群的当前状态
void drawDrones(Mat& frame, vector<Point>& drones) {
    for (const auto& point : drones) {
        circle(frame, point, 5, Scalar(255, 0, 0), -1);
    }
}

int main() {
    // 创建一个窗口用于显示结果
    namedWindow("Formation", WINDOW_NORMAL);

    // 设置无人机数量和初始位置
    int droneCount = 10;
    vector<Point> drones(droneCount);
    for (int i = 0; i < droneCount; i++) {
        drones[i] = Point(rand() % 400 + 50, rand() % 400 + 50);
    }

    // 定义目标梯形队列的四个顶点
    Point topLeft(100, 100);
    Point topRight(300, 100);
    Point bottomLeft(150, 400);
    Point bottomRight(250, 400);

    // 慢慢移动无人机至梯形队列
    double speed = 2.0;  // 调整速度以控制移动过程的速度
    while (true) {
        Mat frame(500, 500, CV_8UC3, Scalar(255, 255, 255));

        // 绘制当前无人机群的状态
        drawDrones(frame, drones);

        // 计算每个无人机的移动向量
        for (int i = 0; i < droneCount; i++) {
            Point targetPos;
            if (i % 2 == 0) {
                // 奇数号无人机从左上角到右下角
                double progress = (double)i / (droneCount - 1);
                targetPos.x = topLeft.x + (bottomRight.x - topLeft.x) * progress;
                targetPos.y = topLeft.y + (bottomRight.y - topLeft.y) * progress;
            } else {
                // 偶数号无人机从右上角到左下角
                double progress = (double)(i - 1) / (droneCount - 1);
                targetPos.x = topRight.x - (topRight.x - bottomLeft.x) * progress;
                targetPos.y = topRight.y + (bottomLeft.y - topRight.y) * progress;
            }

            // 更新无人机位置
            Point& currentPos = drones[i];
            double dx = targetPos.x - currentPos.x;
            double dy = targetPos.y - currentPos.y;
            double distance = sqrt(dx * dx + dy * dy);

            if (distance > speed) {
                double ratio = speed / distance;
                currentPos.x += static_cast<int>(dx * ratio);
                currentPos.y += static_cast<int>(dy * ratio);
            } else {
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

![image](https://github.com/LQepoch/Robotic_Fish_Matlab_Test/assets/43512109/ed83fe93-3359-45a2-b855-995813597a61)
