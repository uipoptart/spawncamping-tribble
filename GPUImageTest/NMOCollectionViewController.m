//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

#import "NMOCollectionViewController.h"
#import "NMOScrollingCell.h"
#import "PTOCRImageScrollView.h"
#import <GPUImage.h>

@interface NMOCollectionViewController ()

@property (strong, nonatomic)GPUImageContrastFilter *contrastFilter;
@property (strong, nonatomic)GPUImageBrightnessFilter *brightnessFilter;
@property (strong, nonatomic) GPUImagePicture *sourcePicture;

@end

@implementation NMOCollectionViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupImageAdjustmentFilters];
}

#pragma mark - GPU Image Helpers

- (void)_setupImageAdjustmentFilters
{
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [self setContrastFilter:contrastFilter];
    [self setBrightnessFilter:brightnessFilter];
    
    [brightnessFilter addTarget:contrastFilter];
}

- (void)_configureFiltersForCell:(NMOScrollingCell *)cell withImage:(UIImage *)image
{
    [cell.gpuImageViewWidth setConstant:image.size.width];
    [cell.gpuImageViewHeight setConstant:image.size.height];
    
    GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageView *gpuImageView = cell.gpuImageView;
    GPUImageBrightnessFilter *brightnessFilter = self.brightnessFilter;
    GPUImageContrastFilter  *contrastFilter = self.contrastFilter;
    
    [contrastFilter removeAllTargets];
    [self.sourcePicture removeAllTargets];
    
    [sourcePicture addTarget:brightnessFilter];
    [brightnessFilter addTarget:contrastFilter];
    [contrastFilter addTarget:gpuImageView];
    [self setSourcePicture:sourcePicture];
    
    [sourcePicture processImageWithCompletionHandler:^{
        [cell.scrollView configureScrollViewForImageSize:image.size];
    }];
}

#pragma mark - Collection View Data Source And Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NMOScrollingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    UIImage *image = [UIImage imageNamed:@"chi.tif"];
    [self _configureFiltersForCell:cell withImage:image];
    
    return cell;
}

@end
