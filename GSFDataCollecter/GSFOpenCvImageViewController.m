//
//  GSFOpenCvImageViewController.m
//  GSFDataCollecter
//
//  Created by Michael Baptist on 2/5/14.
//  Copyright (c) 2014 Michael Baptist - LLNL. All rights reserved.
//

#import "GSFOpenCvImageViewController.h"
#import "GSFImage.h"
#import "GSFOpenCvImageProcessor.h"
#import "GSFDataTransfer.h"

#define OPENCV 1
#define ORIG   2
#define BOTH   3

@interface GSFOpenCvImageViewController () <NSURLSessionTaskDelegate, NSURLSessionDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveData;
@property (nonatomic) NSNumber *sendPref;

@end

@implementation GSFOpenCvImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    GSFOpenCvImageProcessor *pro = [[GSFOpenCvImageProcessor alloc] init];
    NSMutableArray *cycler = [[NSMutableArray alloc] init];
    int i = 0;
    for (GSFData *data in self.originalData) {
        NSNumber *num = [self.originalOrientation objectAtIndex:i];
        if (num.intValue == UIImageOrientationLeft) { // requires 90 clockwise rotation
            if (data.gsfImage.fimage) {
                [cycler addObject:data.gsfImage.fimage];
            }
            if (data.gsfImage.pimage) {
                [cycler addObject:data.gsfImage.pimage];
            }
        } else if (num.intValue == UIImageOrientationUp) { // 90 counter clock
            if (data.gsfImage.fimage) {
                data.gsfImage.fimage = [pro rotateImage:data.gsfImage.fimage byDegrees:-90];
                [cycler addObject:data.gsfImage.fimage];
            }
            if (data.gsfImage.pimage) {
                data.gsfImage.pimage = [pro rotateImage:data.gsfImage.pimage byDegrees:-90];
                [cycler addObject:data.gsfImage.pimage];
            }
        } else if (num.intValue == UIImageOrientationDown) { // 180 rotation.
            if (data.gsfImage.fimage) {
                data.gsfImage.fimage = [pro rotateImage:data.gsfImage.fimage byDegrees:-90];
                [cycler addObject:data.gsfImage.fimage];
            }
            if (data.gsfImage.pimage) {
                data.gsfImage.pimage = [pro rotateImage:data.gsfImage.pimage byDegrees:-90];
                [cycler addObject:data.gsfImage.pimage];
            }
        } else {
            if (data.gsfImage.fimage) {
                [cycler addObject:data.gsfImage.fimage];
            }
            if (data.gsfImage.pimage) {
                [cycler addObject:data.gsfImage.pimage];
            }
        }
        ++i;
    }
    
    self.imageView.animationImages = cycler;
    self.imageView.animationDuration = 4;
    self.imageView.animationRepeatCount = 0;
    [self.imageView startAnimating];
    [self.view bringSubviewToFront:self.toolbar];
}

- (IBAction)sendDataToDB:(id)sender {
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Discard", @"OpenCV Image(s)", @"Original Image(s)", @"Both", nil];
    [menu showInView:self.view];
}

- (IBAction)saveDataToFile:(id)sender {
    GSFDataTransfer *driver = [[GSFDataTransfer alloc] init];
    NSData *saveMe = [driver formatDataAsJSON:self.originalData withFlag:[NSNumber numberWithInteger:BOTH]];
    NSFileManager *man = [[NSFileManager alloc] init];
    NSArray *urls = [man URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *url = [urls objectAtIndex:0];
    url = [url URLByAppendingPathComponent:@"GSFSaveData"];
    NSLog(@"%@", [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]]);
    NSError *error = nil;
    [saveMe writeToURL:[url URLByAppendingPathComponent:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]] options:NSDataWritingAtomic error:&error];
    if (error) {
        NSLog(@"Problem writing to filesystem.\n");
    } else {
        NSLog(@"Write to filesystem succeeded.\n");
    }
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GSFDataTransfer *driver = [[GSFDataTransfer alloc] init];
    if (0 == buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (4 == buttonIndex) {
        // do nothing
    } else {
        dispatch_queue_t networkQueue = dispatch_queue_create("networkQueue", NULL);
        dispatch_async(networkQueue, ^{
            [driver uploadDataArray:[driver formatDataAsJSON:self.originalData withFlag:[NSNumber numberWithInteger:buttonIndex]]];
        });
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
    }
}

@end
