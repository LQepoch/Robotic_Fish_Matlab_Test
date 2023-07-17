#include "opencv2/opencv.hpp"
#include <iostream>
#include <vector>
#include <cmath>

// 定义无人机结构体
struct Drone {
    double x;
    double y;
};

// 计算两个无人机之间的距离
double calculateDistance(const Drone& drone1, const Drone& drone2) {
    double dx = drone1.x - drone2.x;
    double dy = drone1.y - drone2.y;
    return std::sqrt(dx * dx + dy * dy);
}

// 移动无人机到目标点
void moveDroneToTarget(Drone& drone, const Drone& target) {
    double dx = target.x - drone.x;
    double dy = target.y - drone.y;
    double distance = std::sqrt(dx * dx + dy * dy);

    // 如果距离大于5，则朝目标点移动5单位的距离
    if (distance > 5.0) {
        double ratio = 5.0 / distance;
        drone.x += dx * ratio;
        drone.y += dy * ratio;
    }
}

int main() {
    const int imageSize = 800;  // 图像大小
    const int numDrones = 10;   // 无人机数量

    cv::Mat image(imageSize, imageSize, CV_8UC3, cv::Scalar(0, 0, 0));

    Drone startPoint;  // 起点A
    Drone targetPoint; // 目标点B

    startPoint.x = 0.0;
    startPoint.y = 0.0;

    targetPoint.x = 100.0;
    targetPoint.y = 0.0;

    const double initialArea = 10.0; // 初始区域限制在10个单位内
    const double minDistance = 5.0;  // 无人机之间最小距离为5个单位

    std::vector<Drone> drones(numDrones);

    // 初始化无人机位置，随机分布在初始区域内
    for (int i = 0; i < numDrones; ++i) {
        drones[i].x = startPoint.x + (std::rand() / double(RAND_MAX)) * initialArea;
        drones[i].y = startPoint.y + (std::rand() / double(RAND_MAX)) * initialArea;
    }

    // 按照队形排列无人机
    for (int i = 1; i < numDrones; ++i) {
        drones[i].x = drones[i - 1].x + minDistance;
        drones[i].y = drones[i - 1].y;
    }

    // 创建窗口
    cv::namedWindow("Drone Swarm", cv::WINDOW_NORMAL);
    cv::resizeWindow("Drone Swarm", imageSize, imageSize);

    while (true) {
        // 移动无人机到目标点
        bool allDronesReachedTarget = true;
        for (auto& drone : drones) {
            moveDroneToTarget(drone, targetPoint);
            if (calculateDistance(drone, targetPoint) > minDistance) {
                allDronesReachedTarget = false;
            }
        }

        image.setTo(cv::Scalar(0, 0, 0)); // 清空图像

        // 绘制无人机
        for (const auto& drone : drones) {
            cv::circle(image, cv::Point2d(drone.x * 6 + imageSize / 2, drone.y * 6 + imageSize / 2), 5, cv::Scalar(0, 255, 0), -1);
        }

        // 绘制起点和目标点
        cv::circle(image, cv::Point2d(startPoint.x * 6 + imageSize / 2, startPoint.y * 6 + imageSize / 2), 10, cv::Scalar(0, 0, 255), -1);
        cv::circle(image, cv::Point2d(targetPoint.x * 6 + imageSize / 2, targetPoint.y * 6 + imageSize / 2), 10, cv::Scalar(255, 0, 0), -1);

        cv::imshow("Drone Swarm", image);
        cv::waitKey(10);

        // 如果所有无人机都到达了目标点，则结束循环
        if (allDronesReachedTarget) {
            break;
        }
    }

    cv::destroyAllWindows();

    return 0;
}
