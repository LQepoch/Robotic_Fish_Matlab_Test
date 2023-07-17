```matlab
#include <opencv2/opencv.hpp>
#include <vector>
#include <cmath>

using namespace cv;
using namespace std;

class DroneCluster {
public:
    DroneCluster(int numDrones, Point2f startPoint, Point2f targetPoint,
        float range, float minDistance, float movementSpeed);
    void move();
    void draw(Mat& image);
private:
    vector<Point2f> drones;
    Point2f target;
    float range;
    float minDistance;
    float movementSpeed;
};

DroneCluster::DroneCluster(int numDrones, Point2f startPoint, Point2f targetPoint,
    float range, float minDistance, float movementSpeed)
    : range(range), minDistance(minDistance), movementSpeed(movementSpeed) {

    RNG rng;
    for (int i = 0; i < numDrones; ++i) {
        float x = startPoint.x + rng.uniform(-10.f, 10.f);
        float y = startPoint.y + rng.uniform(-10.f, 10.f);
        drones.push_back(Point2f(x, y));
    }

    target = targetPoint;
}

void DroneCluster::move() {
    vector<Point2f> moveVectors(drones.size(), target - drones[0]);

    for (size_t i = 1; i < drones.size(); ++i) {
        Point2f separationVector = drones[0] - drones[i];
        float distance = norm(separationVector);
        float separationFactor = (distance < minDistance) ? 1.f : 0.f;
        separationVector *= separationFactor * (minDistance - distance) / distance;

        moveVectors[i] += separationVector;
    }

    for (size_t i = 0; i < drones.size(); ++i) {
        Point2f movement = moveVectors[i] * movementSpeed / norm(moveVectors[i]);
        drones[i] += movement;
    }
}

void DroneCluster::draw(Mat& image) {
    circle(image, drones[0], 3, Scalar(255, 255, 0), -1);
    circle(image, target, 3, Scalar(0, 0, 255), -1);

    for (size_t i = 0; i < drones.size(); ++i) {
        if (i > 0) {
            line(image, drones[i - 1], drones[i], Scalar(0, 255, 0), 1);
        }
        circle(image, drones[i], 1, Scalar(0, 255, 0), -1);
    }
}

int main() {
    Mat image(500, 500, CV_8UC3, Scalar(0, 0, 0));

    int numDrones = 5;
    Point2f startPoint(250, 250);
    Point2f targetPoint(400, 400);
    float range = 100;
    float minDistance = 5;
    float movementSpeed = 2;

    DroneCluster cluster(numDrones, startPoint, targetPoint, range, minDistance, movementSpeed);

    while (true) {
        image.setTo(Scalar(0, 0, 0));

        cluster.move();
        cluster.draw(image);

        imshow("Drone Cluster", image);

        if (waitKey(30) >= 0) break;
    }

    return 0;
}

```

![image](https://github.com/LQepoch/Robotic_Fish_Matlab_Test/assets/43512109/30e91730-6105-4166-80d4-9b0b783274e7)
