//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

#import "NMOCaptureManager.h"
#import "GPUImage.h"

@interface NMOCaptureManager ()

@property (strong, nonatomic) GPUImageStillCamera *stillCamera;
@property (weak, nonatomic)   GPUImageView *captureView;
@property (strong, nonatomic) GPUImageOutput <GPUImageInput> *adjustmentFilter;
@property (strong, nonatomic) GPUImageOutput <GPUImageInput> *colorFilter;

@end

@implementation NMOCaptureManager

#pragma mark - Setup / Teardown

- (void)setupSessionWithImageView:(GPUImageView *)captureView
{
    GPUImageStillCamera *stillCamera = [[GPUImageStillCamera alloc] init];
    GPUImageGammaFilter *colorFilter = [[GPUImageGammaFilter alloc] init];
    [stillCamera addTarget:colorFilter];
    [colorFilter addTarget:captureView];
    
    self.colorFilter = colorFilter;
    self.stillCamera = stillCamera;
    self.captureView = captureView;
    
    [stillCamera startCameraCapture];
}

- (void)teardownSession
{
    GPUImageStillCamera *stillCamera = self.stillCamera;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [stillCamera stopCameraCapture];
}

- (void)didRecieveMemoryWarning
{
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
}

- (BOOL)captureSessionIsRunning
{
    return self.stillCamera.captureSession.isRunning;
}

- (void)setOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        if (interfaceOrientation == UIInterfaceOrientationUnknown) { // default to portrait if we don't know
            interfaceOrientation = UIInterfaceOrientationPortrait;
        }
        
    self.stillCamera.outputImageOrientation = interfaceOrientation;
}

#pragma mark - Capture Image

- (void)captureImage
{
    GPUImageStillCamera *stillCamera = self.stillCamera;
    
    [stillCamera capturePhotoAsImageProcessedUpToFilter:self.colorFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        NSLog(@"image orientation %ld", (long)processedImage.imageOrientation);
        NSLog(@"image size %f width x %f height", processedImage.size.width, processedImage.size.height);
    }];
}

#pragma mark - Private Helpers

- (void)_resumeCapture
{
    [self.stillCamera resumeCameraCapture];
}

- (void)_pauseCapture
{
    [self.stillCamera pauseCameraCapture];
}

@end