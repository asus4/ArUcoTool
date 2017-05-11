//
//  NSImage+OpenCV.h
//  ArUcoTool
//
//  Created by Koki Ibukuro on 2017/05/11.
//  Copyright © 2017 Koki Ibukuro. All rights reserved.
//


#pragma once

#include <opencv2/opencv.hpp>
#import <AppKit/AppKit.h>

@interface NSImage (OpenCV)

+(NSImage *) imageFromCVMat:(cv::Mat)cvMat;

@end
