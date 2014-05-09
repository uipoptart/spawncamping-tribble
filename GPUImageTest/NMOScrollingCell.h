//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPUImageView;
@class PTOCRImageScrollView;

@interface NMOScrollingCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PTOCRImageScrollView *scrollView;
@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gpuImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gpuImageViewHeight;

@end
