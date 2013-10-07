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


@implementation MHDismissModalViewOptions

- (id)initWithScrollView:(UIScrollView*)scrollView
                   theme:(MHModalTheme)theme
{
    self = [super init];
    if (!self)
        return nil;
    self.scrollView = scrollView;
    self.screenShot = nil;
    self.theme = theme;
    return self;
}
@end

@implementation MHGestureRecognizerWithOptions
-(id)init{
    self = [super init];
    if (!self)
        return nil;
    self.options = nil;
    return self;
}

@end

@implementation UINavigationController (MHDismissModalView)

@dynamic wasUnderZero;
@dynamic lastPoint;

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
    if (scrollView.contentOffset.y<=-64) {
        [scrollView setContentOffset:CGPointMake(0,  -64)];
    }
}



-(void)installMHDismissModalViewWithOptions:(MHDismissModalViewOptions*)options{
    
    [options.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(64, 0, 0, 0)];
    options.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    options.scrollView.backgroundColor = [UIColor clearColor];
    UIImage *image = [[[self.viewControllers objectAtIndex:0] presentingViewController].view screenshotMH];
    UIImageView *backGroundView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    if (options.theme == MHModalThemeBlack) {
        backGroundView.image = [image applyDarkEffect];
    }else{
        backGroundView.image = [image applyLightEffect];
    }
    backGroundView.tag =203;
    if (!options.scrollView) {
        [[[self.viewControllers objectAtIndex:0] view] addSubview:backGroundView];
        [[[self.viewControllers objectAtIndex:0] view] sendSubviewToBack:backGroundView];
    }else{
        [[[self.viewControllers objectAtIndex:0] view] insertSubview:backGroundView belowSubview:options.scrollView];
    }
    
    options.screenShot = image;
    options.bluredBackground = backGroundView;
    
    MHGestureRecognizerWithOptions *panRecognizer = [[MHGestureRecognizerWithOptions alloc] initWithTarget:self action:@selector(scrollRecognizer:)];
    panRecognizer.options = options;
    options.scrollView.delegate =self;
    panRecognizer.delegate = self;
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)scrollRecognizer:(MHGestureRecognizerWithOptions *)recognizer{

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
    
    MHDismissModalViewOptions *options = recognizer.options;
    if (options.scrollView.contentOffset.y==-64 || !options.scrollView) {
        CGPoint translatedPoint = [(UIPanGestureRecognizer*)recognizer translationInView:self.view];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.wasUnderZero =NO;
            self.lastPoint = [(UIPanGestureRecognizer*)recognizer translationInView:self.view].y;
        }
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            [options.scrollView setScrollEnabled:NO];
            if (self.view.frame.origin.y>=0 || !self.wasUnderZero) {
                options.bluredBackground.frame = CGRectMake(0, -(translatedPoint.y-self.lastPoint), options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
                self.view.frame = CGRectMake(0, translatedPoint.y-self.lastPoint, self.view.frame.size.width, self.view.frame.size.height);
                self.wasUnderZero =YES;
                if (self.view.frame.origin.y <0) {
                    options.bluredBackground.frame = CGRectMake(0, 0, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
                    
                    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                }
            }
        }
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            [options.scrollView setScrollEnabled:YES];
            [UIView animateWithDuration:0.4 animations:^{
                if (self.view.frame.origin.y <self.view.frame.size.height/3) {
                    options.bluredBackground.frame = CGRectMake(0, 0, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
                    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                }else{
                    options.bluredBackground.frame = CGRectMake(0, self.view.frame.size.height, options.bluredBackground.frame.size.width, options.bluredBackground.frame.size.height);
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
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end
