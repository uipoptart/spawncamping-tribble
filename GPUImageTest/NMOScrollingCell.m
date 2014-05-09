//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

#import "NMOScrollingCell.h"
#import <GPUImage.h>

@interface NMOScrollingCell () <UIScrollViewDelegate>

@end

@implementation NMOScrollingCell

#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gpuImageView;
}

@end
