//
//  ViewController.m
//  ArUcoTool
//
//  Created by Koki Ibukuro on 2017/05/11.
//  Copyright © 2017 Koki Ibukuro. All rights reserved.
//

#include <opencv2/opencv.hpp>
#include <opencv2/aruco.hpp>
#include <opencv2/aruco/charuco.hpp>


#import "ViewController.h"
#include "NSImage+OpenCV.h"

using namespace cv;

@interface ViewController()

@property (weak) IBOutlet NSImageView *preview;

// model values
@property (nonatomic, readwrite) int markerID;
@property (nonatomic, readwrite) int markerSize;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    std::cout << getBuildInformation() << std::endl;
    
    self.markerID = 1;
    self.markerSize = 256;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)createMarker:(id)sender {
    NSLog(@"create marker");
    Mat img;
    auto dictionary = aruco::getPredefinedDictionary(aruco::PREDEFINED_DICTIONARY_NAME::DICT_4X4_100);
    dictionary->drawMarker(self.markerID,
                           self.markerSize,
                           img);
    self.preview.image = [NSImage imageFromCVMat:img];
    
    [self saveMat:&img
         withName:[NSString stringWithFormat:@"marker%d.png", self.markerID]];
}

- (IBAction)createCharucoBoard:(id)sender {
    NSLog(@"create charuco board");
    
    int squaresX = 6;
    int squaresY = 8;
    int squareLength = 256;
    int markerLength = 128;
    int margins = squareLength - markerLength;
    
    Mat img;
    auto dictionary = aruco::getPredefinedDictionary(aruco::PREDEFINED_DICTIONARY_NAME::DICT_4X4_100);
    dictionary->drawMarker(self.markerID,
                           self.markerSize,
                           img);
    cv::Size imageSize;
    imageSize.width = squaresX * squareLength + 2 * margins;
    imageSize.height = squaresY * squareLength + 2 * margins;
    
    auto board = aruco::CharucoBoard::create(squaresX, squaresY,
                                             (float)squareLength,
                                             (float)markerLength,
                                             dictionary);
    board->draw(imageSize, img, margins);
    
    self.preview.image = [NSImage imageFromCVMat:img];
    
    [self saveMat:&img
         withName:@"charuco_board.png"];
}

- (void)saveMat:(Mat*) mat withName:(NSString*) name {
    // copy
    Mat image = *mat;
    
    // make dialog
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.canCreateDirectories = YES;
    panel.nameFieldStringValue = name;
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            // png : comp level 9
            std::vector<int> params = {CV_IMWRITE_PNG_COMPRESSION, 9};
            imwrite(panel.URL.path.UTF8String, image, params);
        }
    }];
}

@end
