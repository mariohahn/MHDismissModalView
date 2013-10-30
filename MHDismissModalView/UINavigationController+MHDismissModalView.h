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

@interface MHDismissIgnore : NSObject
@property (nonatomic, strong) NSString *viewControllerName;
@property (nonatomic) BOOL ignoreBlurEffect;
@property (nonatomic) BOOL ignoreGesture;

- (id)initWithViewControllerName:(NSString*)viewControllerName
                ignoreBlurEffect:(BOOL)ignoreBlurEffect
                   ignoreGesture:(BOOL)ignoreGesture;
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
-(void)installWithTheme:(MHModalTheme)theme withIgnoreObjects:(NSArray *)ignoreObjects;
-(void)installWithCustomColor:(UIColor*)blurColor withIgnoreObjects:(NSArray *)ignoreObjects;
@end




@interface UINavigationController (MHDismissModalView)<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic) BOOL wasUnderZero;
@property (nonatomic) BOOL hasScrollView;
@property CGFloat lastPoint;

//Call the method in the ViewDidLoad method
-(void)installMHDismissModalViewWithOptions:(MHDismissModalViewOptions*)options;

@end
