//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) GPUImageBrightnessFilter *brightnessFilter;
@property (strong, nonatomic) GPUImageContrastFilter *contrastFilter;
@property (strong, nonatomic) GPUImagePicture *sourcePicture;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gpuImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gpuImageViewHeight;
@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"Alice.png"];
    [self _setupDisplayFilteringWithImage:image];
    [self _configureScrollViewForImageSize:image.size];
    
}

#pragma mark - Private API

- (void)_setupDisplayFilteringWithImage:(UIImage *)image
{
    [self.gpuImageViewWidth setConstant:image.size.width];
    [self.gpuImageViewHeight setConstant:image.size.height];

    GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageView *gpuImageView = self.gpuImageView;
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [self setContrastFilter:contrastFilter];
    [self setBrightnessFilter:brightnessFilter];
    [self setSourcePicture: sourcePicture];

    [sourcePicture addTarget:brightnessFilter];
    [brightnessFilter addTarget:contrastFilter];
    [contrastFilter addTarget:gpuImageView];
    [sourcePicture processImage];
}

- (void)_configureScrollViewForImageSize:(CGSize)imageSize
{
    UIScrollView *scrollView = self.scrollView;
    CGSize boundsSize = scrollView.bounds.size;
    
    CGFloat xScale = boundsSize.width  / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    
    BOOL imagePortrait = imageSize.height > imageSize.width;
    BOOL phonePortrait = boundsSize.height > boundsSize.width;
    CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);
    
    CGFloat maxScale = 1.0;
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    [scrollView setMaximumZoomScale:maxScale];
    [scrollView setMinimumZoomScale:minScale];
    [scrollView setZoomScale:minScale];
}

#pragma mark - Scroll View Delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gpuImageView;
}

@end
