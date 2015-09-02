//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

@import UIKit;
@class GPUImageView;
@class GPUImageStillCamera;

@interface NMOCaptureManager : NSObject

- (void)setupSessionWithImageView:(GPUImageView *)imageView;
- (void)teardownSession;
- (void)didRecieveMemoryWarning;
- (BOOL)captureSessionIsRunning;
- (void)captureImage;
- (void)setOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
