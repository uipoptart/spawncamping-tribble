//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

#import "NMOCaptureViewController.h"
#import "NMOCaptureManager.h"
#import <GPUImage.h>

@interface NMOCaptureViewController ()

@property (strong, nonatomic) NMOCaptureManager *captureManager;
@property (weak, nonatomic) IBOutlet GPUImageView *captureView;

@end

@implementation NMOCaptureViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NMOCaptureManager *captureManager = self.captureManager;
    [captureManager setupSessionWithImageView:self.captureView];
    UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationPortrait;
    
    if (self.supportedInterfaceOrientations != UIInterfaceOrientationMaskPortrait) { //if we can rotate this view, do the same to capture session
        interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    }
    
    [captureManager setOrientation:interfaceOrientation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.captureManager teardownSession];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.captureManager didRecieveMemoryWarning];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask orientationMask = [super supportedInterfaceOrientations];
    
    if (orientationMask == UIInterfaceOrientationMaskAllButUpsideDown) { // Make the camera remain in portrait on iphone
        orientationMask = UIInterfaceOrientationMaskPortrait;
    }
    
    return orientationMask;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.captureManager setOrientation:[self _interfaceOrientationForDeviceOrientation:[[UIDevice currentDevice] orientation]]];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - IBAction

- (IBAction)tappedShutterButton:(id)sender
{
    [self.captureManager captureImage];
}

#pragma mark - Private API

- (UIInterfaceOrientation)_interfaceOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    UIInterfaceOrientation newOrientation = UIInterfaceOrientationUnknown;
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            newOrientation = UIInterfaceOrientationLandscapeRight; //reversed :(
            break;
            
        case UIDeviceOrientationLandscapeRight:
            newOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationPortrait:
            newOrientation = UIInterfaceOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            newOrientation = UIInterfaceOrientationPortraitUpsideDown;
            break;
        default:
            break;
    }
    
    return newOrientation;
}


#pragma mark - Lazy Load

- (NMOCaptureManager *)captureManager
{
    if (!_captureManager) {
        NMOCaptureManager *temp = [[NMOCaptureManager alloc] init];
        [self setCaptureManager:temp];
    }
    return _captureManager;
}

@end