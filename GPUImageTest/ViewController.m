//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

#import "ViewController.h"
#import "GPUimage.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;
@property (strong, nonatomic) GPUImageTiltShiftFilter *filter;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDisplayFiltering];
}

#pragma mark - Private API

- (void)setupDisplayFiltering
{
    UIImage *image = [UIImage imageNamed:@"WID-small.jpg"];
    
    GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageView *gpuImageView = self.gpuImageView;
    GPUImageTiltShiftFilter *filter = [[GPUImageTiltShiftFilter alloc] init];
   
    [filter forceProcessingAtSizeRespectingAspectRatio:gpuImageView.sizeInPixels];
    [sourcePicture addTarget:filter];
    [filter addTarget:gpuImageView];
    
    [sourcePicture processImage];
}

@end
