//
//  Copyright (c) 2014 Nat Osten. All rights reserved.
//

#import "PTOCRImageScrollView.h"

@interface PTOCRImageScrollView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subviewYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subviewXConstraint;
@property (weak, nonatomic) IBOutlet UIView *viewToCenter;

@end

@implementation PTOCRImageScrollView

- (void)layoutSubviews
{
    [self _centerSubview:self.viewToCenter];
    [super layoutSubviews];
}

#pragma mark - Public API

- (void)configureScrollViewForImageSize:(CGSize)imageSize
{
    CGSize boundsSize = self.bounds.size;
    
    CGFloat xScale = boundsSize.width  / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    
    BOOL imagePortrait = imageSize.height > imageSize.width;
    BOOL phonePortrait = boundsSize.height > boundsSize.width;
    CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);
    
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    [self setMaximumZoomScale:maxScale];
    [self setMinimumZoomScale:minScale];
    [self setZoomScale:minScale];
}

#pragma mark - Private API

- (void)_centerSubview:(UIView *)subview
{
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = subview.frame.size;
    CGPoint newImageOrigin = CGPointZero;
    
    if (imageSize.width < boundsSize.width) {
        newImageOrigin.x = (boundsSize.width - imageSize.width) / 2;
    }
    if (imageSize.height < boundsSize.height) {
        newImageOrigin.y = (boundsSize.height - imageSize.height) / 2;
    }
    
    [self.subviewXConstraint setConstant:newImageOrigin.x];
    [self.subviewYConstraint setConstant:newImageOrigin.y];
}

@end