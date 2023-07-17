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
    return std::sqrt(dx*dx + dy*dy);
}

// 移动无人机到目标点
void moveDroneToTarget(Drone& drone, const Drone& target) {
    double dx = target.x - drone.x;
    double dy = target.y - drone.y;
    double distance = std::sqrt(dx*dx + dy*dy);

    // 如果距离大于5，则朝目标点移动5单位的距离
    if (distance > 5.0) {
        double ratio = 5.0 / distance;
        drone.x += dx * ratio;
        drone.y += dy * ratio;
    }
}

int main() {
    Drone startPoint;  // 起点A
    Drone targetPoint; // 目标点B

    startPoint.x = 0.0;
    startPoint.y = 0.0;

    targetPoint.x = 100.0;
    targetPoint.y = 0.0;

    const int numDrones = 10; // 无人机数量
    const double initialArea = 10.0; // 初始区域限制在10个单位内
    const double minDistance = 5.0; // 无人机之间最小距离为5个单位

    std::vector<Drone> drones(numDrones);

    // 初始化无人机位置，随机分布在初始区域内
    for (int i = 0; i < numDrones; ++i) {
        drones[i].x = startPoint.x + (std::rand() / double(RAND_MAX)) * initialArea;
        drones[i].y = startPoint.y + (std::rand() / double(RAND_MAX)) * initialArea;
    }

    // 按照队形排列无人机
    for (int i = 1; i < numDrones; ++i) {
        drones[i].x = drones[i-1].x + minDistance;
        drones[i].y = drones[i-1].y;
    }

    // 移动无人机到目标点
    while (calculateDistance(drones[0], targetPoint) > minDistance) {
        // 显示当前无人机位置和目标点
        std::cout << "Current drone positions: ";
        for (const auto& drone : drones) {
            std::cout << "(" << drone.x << ", " << drone.y << ") ";
        }
        std::cout << "Target point: (" << targetPoint.x << ", " << targetPoint.y << ")" << std::endl;

        // 移动每个无人机到目标点
        for (auto& drone : drones) {
            moveDroneToTarget(drone, targetPoint);
        }
    }

    // 显示最终无人机位置和目标点
    std::cout << "Final drone positions: ";
    for (const auto& drone : drones) {
        std::cout << "(" << drone.x << ", " << drone.y << ") ";
    }
    std::cout << "Target point: (" << targetPoint.x << ", " << targetPoint.y << ")" << std::endl;

    return 0;
}
