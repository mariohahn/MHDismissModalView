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
    MHModalThemeWhite,
    MHModalThemeNoBlur,
    MHModalThemeExtraWhite,
    MHModalThemeCustomBlurColor
};

@interface UIView (MHScreenShot)
- (UIImage *)screenshotMH;
@end

@interface MHDismissModalViewOptions : NSObject
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) MHModalTheme theme;

- (id)initWithScrollView:(UIScrollView*)scrollView
                   theme:(MHModalTheme)theme;

@end

@interface MHGestureRecognizerWithOptions : UIPanGestureRecognizer
@property (strong, nonatomic) MHDismissModalViewOptions *options;
@property (nonatomic) id objectCameFrom;

@end

@interface MHDismissSharedManager : NSObject

+ (MHDismissSharedManager *)sharedDismissManager;
-(void)installWithTheme:(MHModalTheme)theme;
-(void)installWithCustomColor:(UIColor*)blurColor;
@end




@interface UINavigationController (MHDismissModalView)<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic) BOOL wasUnderZero;
@property (nonatomic) BOOL hasScrollView;
@property CGFloat lastPoint;

//Call the method in the ViewDidLoad method
-(void)installMHDismissModalViewWithOptions:(MHDismissModalViewOptions*)options;

@end
