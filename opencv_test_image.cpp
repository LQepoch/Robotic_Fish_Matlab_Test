#include <opencv2/opencv.hpp>

int main() {
    // 读取图像
    cv::Mat image = cv::imread("testimage.jpg");

    if (image.empty()) {
        std::cerr << "Failed to read image!" << std::endl;
        return -1;
    }

    // 创建窗口并显示图像
    cv::namedWindow("Image", cv::WINDOW_NORMAL);
    cv::imshow("Image", image);

    // 等待按下任意键后关闭窗口
    cv::waitKey(0);
    cv::destroyAllWindows();

    return 0;
}
