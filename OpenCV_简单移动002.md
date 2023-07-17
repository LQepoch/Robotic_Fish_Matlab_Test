```c++
#include <opencv2/opencv.hpp>
#include <iostream>
#include <cmath>

using namespace std;
using namespace cv;

class Drone {
public:
    Point2f position;
    Point2f target;

    void move() {
        float dx = target.x - position.x;
        float dy = target.y - position.y;
        float distance = sqrt(dx*dx + dy*dy);

        if (distance > 5) {
            position.x += 5*dx/distance;
            position.y += 5*dy/distance;
        }
    }
};

int main() {
    // Initialize drones with random positions within a 10x10 range.
    vector<Drone> drones(10);
    srand(time(NULL));
    for (int i = 0; i < drones.size(); i++) {
        drones[i].position.x = rand()%10;
        drones[i].position.y = rand()%10;
    }

    // Set target point and maximum range.
    Point2f target(80, 80);
    float maxRange = 100;

    // Create OpenCV window for visualization.
    namedWindow("Drones", WINDOW_NORMAL);
    resizeWindow("Drones", 800, 800); // Adjust the window size as per your preference

    while (true) {
        Mat canvas(maxRange, maxRange, CV_8UC3, Scalar(255, 255, 255));

        // Move drones towards the target.
        for (int i = 0; i < drones.size(); i++) {
            drones[i].target = target;
            drones[i].move();

            // Draw drone positions as circles on the canvas.
            circle(canvas, drones[i].position, 2, Scalar(0, 0, 0), FILLED);
        }

        // Draw the target point.
        circle(canvas, target, 4, Scalar(0, 255, 0), FILLED);

        // Draw lines to represent the movement trajectory of each drone.
        for (int i = 0; i < drones.size(); i++) {
            line(canvas, drones[i].position, drones[i].target, Scalar(0, 0, 255));
        }

        imshow("Drones", canvas);

        // Break the loop if all drones have reached the target point.
        bool allReached = true;
        for (int i = 0; i < drones.size(); i++) {
            float dx = drones[i].target.x - drones[i].position.x;
            float dy = drones[i].target.y - drones[i].position.y;
            float distance = sqrt(dx*dx + dy*dy);

            if (distance > 5) {
                allReached = false;
                break;
            }
        }

        if (allReached) {
            break;
        }

        waitKey(100);
    }

    destroyAllWindows();
    return 0;
}

```

![image](https://github.com/LQepoch/Robotic_Fish_Matlab_Test/assets/43512109/8e79823f-0d3d-484b-bbbb-93e78a2c96d2)
