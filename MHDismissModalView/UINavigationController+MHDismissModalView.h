//
//  ViewController.h
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHModalTheme) {
    MHModalThemeBlack,
    MHModalThemeWhite
};

@interface UIView (MHScreenShot)
- (UIImage *)screenshotMH;
@end

@interface MHDismissModalViewOptions : NSObject
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *screenShot;
@property (nonatomic, strong) UIImageView *bluredBackground;
@property (nonatomic) MHModalTheme theme;

- (id)initWithScrollView:(UIScrollView*)scrollView
              screenShot:(UIImage*)screenShot
                   theme:(MHModalTheme)theme;
@end

@interface MHGestureRecognizerWithOptions : UIPanGestureRecognizer
@property (strong, nonatomic) MHDismissModalViewOptions *options;
@end

@interface UINavigationController (MHDismissModalView)<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic) BOOL wasUnderZero;
@property CGFloat lastPoint;

-(void)installMHDismissModalViewWithOptions:(MHDismissModalViewOptions*)options;
@end
