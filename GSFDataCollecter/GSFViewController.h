//
//  GSFViewController.h
//  GSFDataCollecter
//
//  Created by Michael Baptist - LLNL on 1/10/14.
//  Copyright (c) 2014 Michael Baptist - LLNL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSFTaggedVCViewController.h"
#import "GSFSensorIOController.h"
#import "GSFNoiseLevelController.h"

/**
 *  The main class used to collect image data for the GSFDataCollector application.
 */
@interface GSFViewController : GSFTaggedVCViewController

/**
 *  Property to determine if facial detection is to be used.
 */
@property (nonatomic) BOOL faceDetect;

/**
 *  Property to determine if pedestrian (people) detection is to be used.
 */
@property (nonatomic) BOOL personDetect;

/**
 *  Determines if noise switch it on.
 */
@property (nonatomic) BOOL noiseSwitch;


@property (nonatomic) GSFNoiseLevelController *noiseMonitor;
@property (nonatomic) GSFSensorIOController *sensorIO;

@end
