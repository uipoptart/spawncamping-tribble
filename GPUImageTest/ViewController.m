//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

#import "ViewController.h"
#import "GPUimage.h"
#import "PTOCRImageScrollView.h"

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) GPUImageBrightnessFilter *brightnessFilter;
@property (strong, nonatomic) GPUImageContrastFilter *contrastFilter;
@property (strong, nonatomic) GPUImagePicture *sourcePicture;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gpuImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gpuImageViewHeight;
@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;
@property (weak, nonatomic) IBOutlet PTOCRImageScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDisplayFiltering];}

#pragma mark - IBAction

- (IBAction)crop:(id)sender
{
    GPUImagePicture *originalPicture = self.sourcePicture;
    GPUImageBrightnessFilter *brightnessFilter = self.brightnessFilter;
    
    [originalPicture removeTarget:brightnessFilter];
    
    UIImage *croppedImage = [UIImage imageNamed:@"WID-small-two.jpg"];
    GPUImagePicture *newSourcePicture = [[GPUImagePicture alloc] initWithImage:croppedImage];
    [self setSourcePicture:newSourcePicture];
    [newSourcePicture addTarget:brightnessFilter];
    
    [newSourcePicture processImage];
}

- (IBAction)contrastValueChanged:(id)sender
{
    CGFloat value = [(UISlider *)sender value];
    [self.contrastFilter setContrast:value];
    
    [self.sourcePicture processImage];
}

- (IBAction)brightnessValueChanged:(id)sender
{
    CGFloat value = [(UISlider *)sender value];
    [self.brightnessFilter setBrightness:value];
    
    [self.sourcePicture processImage];
}

#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gpuImageView;
}

#pragma mark - Private API

- (void)setupDisplayFiltering
{
    UIImage *image = [UIImage imageNamed:@"WID-small.jpg"];
    
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
    
    [sourcePicture processImageWithCompletionHandler:^{
        [self.scrollView configureScrollViewForImageSize:image.size];
    }];
}

@end
