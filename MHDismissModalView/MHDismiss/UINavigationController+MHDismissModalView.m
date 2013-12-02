//
//  ViewController.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "UINavigationController+MHDismissModalView.h"
#import <objc/runtime.h>
#import "UIImage+ImageEffects.h"

NSString * const WAS_UNDER_ZERO = @"WAS_UNDER_ZERO";
NSString * const LAST_POINT = @"LAST_POINT";
NSString * const HAS_SCROLLVIEW = @"HAS_SCROLLVIEW";



@implementation MHDismissIgnore

- (id)initWithViewControllerName:(NSString*)viewControllerName
                ignoreBlurEffect:(BOOL)ignoreBlurEffect
                   ignoreGesture:(BOOL)ignoreGesture{
    self = [super init];
  
    if (!self)
        return nil;
    
    self.viewControllerName = viewControllerName;
    self.ignoreBlurEffect = ignoreBlurEffect;
    self.ignoreGesture = ignoreGesture;
    self.ignoreViewController = NO;
    return self;
}


@end


@interface MHDismissModalViewOptions()
@property (nonatomic, strong) UIImage *screenShot;
@property (nonatomic, strong) UIImageView *bluredBackground;
@property (nonatomic, strong) UIColor *customColor;
@property (nonatomic, strong) MHDismissIgnore *ignore;
@end

@implementation MHDismissModalViewOptions

- (id)initWithScrollView:(UIScrollView*)scrollView
                   theme:(MHModalTheme)theme{
    self = [super init];
    
    if (!self)
        return nil;
    
    self.scrollView = scrollView;
    self.screenShot = nil;
    self.theme = theme;
    self.customColor =nil;
    return self;
}

@end

@interface MHDismissSharedManager()
@property (nonatomic, strong) UINavigationController *currentNav;
@property (assign) id<UIScrollViewDelegate> scrollViewDelegate;
@end


@implementation MHDismissSharedManager

+ (MHDismissSharedManager *)sharedDismissManager{
    static MHDismissSharedManager *sharedDismissManagerInstance = nil;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        sharedDismissManagerInstance = [[self alloc] init];
    });
    return sharedDismissManagerInstance;
}
-(void)installWithCustomColor:(UIColor *)blurColor  withIgnoreObjects:(NSArray *)ignoreObjects{
    MHDismissModalViewOptions *options = [[MHDismissModalViewOptions alloc]initWithScrollView:nil theme:MHModalThemeCustomBlurColor];
    options.customColor = blurColor;
    [self addObserverToInstallMHDismissWithOptions:options ignoreObjects:ignoreObjects];
}

-(void)addObserverToInstallMHDismissWithOptions:(MHDismissModalViewOptions*)options  ignoreObjects:(NSArray *)ignoreObjects{
    
    NSString *oberserverName = @"UINavigationController";
    oberserverName = [[oberserverName stringByAppendingString:@"DidShowViewController"]stringByAppendingString:@"Notification"];
    [[NSNotificationCenter defaultCenter]addObserverForName:oberserverName object:nil queue:nil usingBlock:^(NSNotification *note) {
            NSString *objectForKey = @"UINavigationController";
            objectForKey = [objectForKey stringByAppendingString:@"NextVisibleViewController"];
        
        
        UIViewController *viewController =  [[note userInfo] objectForKey:objectForKey];
        if (![viewController.navigationController isEqual:[MHDismissSharedManager sharedDismissManager].currentNav]) {
            [MHDismissSharedManager sharedDismissManager].currentNav = nil;
        }
        id rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            rootViewController = [rootViewController viewControllers].firstObject;
        }
        MHDismissIgnore *ignoreObject =nil;
        NSString *currentViewController = NSStringFromClass([viewController class]);

        for (MHDismissIgnore *ignore in ignoreObjects) {
            if ([currentViewController isEqualToString:ignore.viewControllerName]) {
                ignoreObject = ignore;
                break;
            }
        }
        
        BOOL firstViewControllerOfTabBar = NO;
        if (viewController.tabBarController) {
            for (id controller in viewController.tabBarController.viewControllers) {
                if ([controller isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *nav = (UINavigationController*)controller;
                    if (nav.viewControllers.count) {
                        if ([nav.viewControllers.firstObject isEqual:viewController]) {
                            firstViewControllerOfTabBar =YES;
                            break;
                        }
                    }
                }
            }
        }
        BOOL firstNavigationViewControler = YES;
        if (viewController.navigationController) {
            if (![viewController.navigationController.viewControllers.firstObject isEqual:viewController]){
                firstNavigationViewControler =NO;
            }
        }
        
        BOOL isAppleComposeViewController = NO;
        for (NSString *string in @[@"MFMailComposeInternalView",@"CKSMSCompose",@"UIPrintPanelTableView"]) {
            if ([currentViewController isEqualToString:[string stringByAppendingString:@"Controller"]]) {
                isAppleComposeViewController =YES;
            }
        }
        
        
        
        if (![rootViewController isEqual:viewController] && !isAppleComposeViewController && !firstViewControllerOfTabBar &&  firstNavigationViewControler && ![[MHDismissSharedManager sharedDismissManager].currentNav isEqual:viewController.navigationController]) {
            id firstObject;
            if ([viewController view].subviews.count >=1) {
                firstObject =[viewController view].subviews.firstObject;
            }
            if (self.ignore) {
                ignoreObject = [[MHDismissIgnore alloc]initWithViewControllerName:currentViewController ignoreBlurEffect:NO ignoreGesture:NO];
                self.ignore(ignoreObject);
            }
            
            
            [MHDismissSharedManager sharedDismissManager].currentNav =viewController.navigationController;
            MHDismissModalViewOptions *newOptions = [[MHDismissModalViewOptions alloc] initWithScrollView:firstObject
                                                                                                    theme:MHModalThemeWhite];
            newOptions.ignore = ignoreObject;
            newOptions.theme = options.theme;
            newOptions.customColor = options.customColor;
            
            if (!ignoreObject.ignoreViewController) {
                if ([firstObject isKindOfClass:[UIScrollView class]]) {
                    [viewController.navigationController installMHDismissModalViewWithOptions:newOptions];
                }else{
                    newOptions.scrollView = nil;
                    [viewController.navigationController installMHDismissModalViewWithOptions:newOptions];
                }
            }

        }else{


        }
    }];
}


-(void)installWithTheme:(MHModalTheme)theme
        withIgnoreBlock:(void(^)(MHDismissIgnore *ignore))IgnoreBlock{
    MHDismissModalViewOptions *options = [[MHDismissModalViewOptions alloc]initWithScrollView:nil theme:theme];
    self.ignore = IgnoreBlock;
    [self addObserverToInstallMHDismissWithOptions:options ignoreObjects:nil];
}

-(void)installWithTheme:(MHModalTheme)theme withIgnoreObjects:(NSArray *)ignoreObjects{
    MHDismissModalViewOptions *options = [[MHDismissModalViewOptions alloc]initWithScrollView:nil theme:theme];
    [self addObserverToInstallMHDismissWithOptions:options ignoreObjects:ignoreObjects];
}

@end

@implementation UIView (MHScreenShot)

- (UIImage *)screenshotMH{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end



@implementation MHGestureRecognizerWithOptions
-(id)init{
    self = [super init];
    if (!self)
        return nil;
    self.objectCameFrom =nil;
    self.options = nil;
    return self;
}

@end

@implementation UINavigationController (MHDismissModalView)

@dynamic wasUnderZero;
@dynamic lastPoint;
@dynamic hasScrollView;


-(void)setHasScrollView:(BOOL)hasScrollView{
    objc_setAssociatedObject(self, &HAS_SCROLLVIEW, @(hasScrollView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)hasScrollView{
    return [objc_getAssociatedObject(self, &HAS_SCROLLVIEW) boolValue];
}

-(void)setWasUnderZero:(BOOL)wasUnderZero{
    objc_setAssociatedObject(self, &WAS_UNDER_ZERO, @(wasUnderZero), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)wasUnderZero{
    return [objc_getAssociatedObject(self, &WAS_UNDER_ZERO) boolValue];
}
-(void)setLastPoint:(CGFloat)lastPoint{
    objc_setAssociatedObject(self, &LAST_POINT, @(lastPoint), OBJC_ASSOCIATION_COPY);
}
-(CGFloat)lastPoint{
    return [objc_getAssociatedObject(self, &LAST_POINT) floatValue];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.hasScrollView) {
        if (self.view.frame.origin.y>1) {
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
        if (scrollView.contentOffset.y<0) {
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }else{
        if (scrollView.contentOffset.y<=-([self offsetHeight])) {
            [scrollView setContentOffset:CGPointMake(0,  -([self offsetHeight]))];
        }else{
            scrollView.delegate = [MHDismissSharedManager sharedDismissManager].scrollViewDelegate;
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollView.delegate = [MHDismissSharedManager sharedDismissManager].scrollViewDelegate;
}

-(CGFloat)offsetHeight{
    if (OSVersion >=7) {
      return  self.navigationBar.frame.size.height+20;
    }
    return 0;
}

-(void)installMHDismissModalViewWithOptions:(MHDismissModalViewOptions*)options{
    UIImage *image = [[self.viewControllers.firstObject presentingViewController].view screenshotMH];
    UIImageView *backGroundView =[[UIImageView alloc]initWithFrame:CGRectMake(0, -64, image.size.width, image.size.height)];
    if (OSVersion >=7) {
        backGroundView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    switch (options.theme) {
        case MHModalThemeBlack:{
            backGroundView.image = [image applyDarkEffect];
        }
            break;
        case MHModalThemeWhite:{
            backGroundView.image = [image applyLightEffect];
        }
            break;
        case MHModalThemeExtraWhite:{
            backGroundView.image = [image applyExtraLightEffect];
        }
            break;
        case MHModalThemeCustomBlurColor:{
            backGroundView.image = [image applyTintEffectWithColor:options.customColor];
        }
            break;
            
        default:
            break;
    }
    backGroundView.tag =203;
    if (options.theme != MHModalThemeNoBlur) {
        [options.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake([self offsetHeight], 0, 0, 0)];
        options.scrollView.contentInset = UIEdgeInsetsMake([self offsetHeight], 0, 0, 0);
        options.scrollView.backgroundColor = [UIColor clearColor];
        if (!options.ignore.ignoreBlurEffect) {
        if (!options.scrollView) {
            [[self.viewControllers.firstObject view] addSubview:backGroundView];
            [[self.viewControllers.firstObject view] sendSubviewToBack:backGroundView];
        }else{
            [[self.viewControllers.firstObject view] insertSubview:backGroundView belowSubview:options.scrollView];
        }
        }
    }
    options.screenShot = image;
    options.bluredBackground = backGroundView;
    
    MHGestureRecognizerWithOptions *panRecognizer = [[MHGestureRecognizerWithOptions alloc] initWithTarget:self action:@selector(scrollRecognizerView:)];
    panRecognizer.options = options;
    panRecognizer.delegate = self;
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.minimumNumberOfTouches = 1;
    if (!options.ignore.ignoreGesture || !options.ignore) {
        [[self.viewControllers.firstObject view] addGestureRecognizer:panRecognizer];
    }
    
    
    if (options.scrollView) {
        [MHDismissSharedManager sharedDismissManager].scrollViewDelegate = options.scrollView.delegate;
        self.hasScrollView =YES;
        MHGestureRecognizerWithOptions *panRecognizer = [[MHGestureRecognizerWithOptions alloc] initWithTarget:self action:@selector(scrollRecognizerNavbar:)];
        panRecognizer.options = options;
        panRecognizer.maximumNumberOfTouches = 1;
        panRecognizer.minimumNumberOfTouches = 1;
        if (!options.ignore.ignoreGesture || !options.ignore) {
            [self.navigationBar addGestureRecognizer:panRecognizer];
        }
    }else{
        self.hasScrollView =NO;
    }
}


-(void)setImageToWindow:(MHGestureRecognizerWithOptions*)recognizer{
    bool foundBackground =NO;
    for (id view in [[UIApplication sharedApplication] keyWindow].subviews) {
        if ([view isKindOfClass:[UIImageView class]] && [view tag]==203) {
            foundBackground = YES;
        }
    }
    if (!foundBackground) {
        UIImageView *view =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, recognizer.options.screenShot.size.width, recognizer.options.screenShot.size.height)];
        view.image = recognizer.options.screenShot;
        view.tag =203;
        [[[UIApplication sharedApplication] keyWindow]insertSubview:view belowSubview:self.view];
    }
    
}

-(void)scrollRecognizerNavbar:(MHGestureRecognizerWithOptions *)recognizer{
    [self setImageToWindow:recognizer];
    [self changeFrameWithRecognizer:recognizer];
}
- (void)scrollRecognizerView:(MHGestureRecognizerWithOptions *)recognizer{
    [self setImageToWindow:recognizer];
    MHDismissModalViewOptions *options = recognizer.options;
    if (options.scrollView.contentOffset.y==-([self offsetHeight]) || !options.scrollView) {
        [self changeFrameWithRecognizer:recognizer];
    }
}

-(void)changeFrameWithRecognizer:(MHGestureRecognizerWithOptions*)recognizer{
    MHDismissModalViewOptions *options = recognizer.options;
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)recognizer translationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.wasUnderZero =NO;
        self.lastPoint = [(UIPanGestureRecognizer*)recognizer translationInView:self.view].y;
        
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [options.scrollView setScrollEnabled:NO];
        if (self.view.frame.origin.y>=0 || !self.wasUnderZero) {
            if (OSVersion >=7) {
                options.bluredBackground.frame = CGRectMake(0, -(translatedPoint.y-self.lastPoint), options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
            }else{
                options.bluredBackground.frame = CGRectMake(0, -(translatedPoint.y-self.lastPoint)-64, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
            }
            self.view.frame = CGRectMake(0, translatedPoint.y-self.lastPoint, self.view.frame.size.width, self.view.frame.size.height);
            self.wasUnderZero =YES;
            if (self.view.frame.origin.y <0) {
                if (OSVersion >=7) {
                    options.bluredBackground.frame = CGRectMake(0, 0, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
                }else{
                    options.bluredBackground.frame = CGRectMake(0, -64, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
                }
                self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            }
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [options.scrollView setScrollEnabled:YES];
        if (options.scrollView) {
            options.scrollView.delegate = [MHDismissSharedManager sharedDismissManager].scrollViewDelegate;
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            if (self.view.frame.origin.y <self.view.frame.size.height/3) {
                if (OSVersion >=7) {
                    options.bluredBackground.frame = CGRectMake(0, 0, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
                }else{
                    options.bluredBackground.frame = CGRectMake(0, -64, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
                }
                self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            }else{
                if (OSVersion >=7) {
                    options.bluredBackground.frame = CGRectMake(0, -self.view.frame.size.height, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
                }else{
                    options.bluredBackground.frame = CGRectMake(0, -self.view.frame.size.height-64, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
                }
                self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            }
        } completion:^(BOOL finished) {
            if (self.view.frame.origin.y == self.view.frame.size.height) {
                [self dismissViewControllerAnimated:NO completion:^{
                    for (id view in [[UIApplication sharedApplication] keyWindow].subviews) {
                        if ([view isKindOfClass:[UIImageView class]] && [view tag]==203){
                            [view removeFromSuperview];
                        }
                    }
                }];
            }
        }];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)otherGestureRecognizer.view;
        scrollView.delegate = self;
        if (!self.hasScrollView && scrollView.contentOffset.y >=0) {
            if (scrollView.contentOffset.y ==0) {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}


@end
