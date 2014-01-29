//
//  GSFOpenCvImageProcessor.h
//  GSFDataCollecter
//
//  Created by Michael Baptist on 1/29/14.
//  Copyright (c) 2014 Michael Baptist - LLNL. All rights reserved.
//
//  Complex Hand Wavey Class.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <opencv2/highgui/cap_ios.h>
using namespace cv;

@interface GSFOpenCvImageProcessor : NSObject

// convert image from UIImage to cvMat format to use the opencv framework.
- (cv::Mat)cvMatFromUIImage:(UIImage *)image;

// conver image from cvMat to UIImage for after the image is processed.
- (UIImage *)UIImageFromCvMat:(cv::Mat)cvMatImage;

@end