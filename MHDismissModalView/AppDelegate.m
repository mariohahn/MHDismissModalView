//
//  AppDelegate.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "AppDelegate.h"
#import "UINavigationController+MHDismissModalView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //Global Call to install MHDismiss
    MHDismissIgnore *withoutScroll = [[MHDismissIgnore alloc]initWithViewControllerName:@"ModalViewControllerWithoutScrollView"
                                                                       ignoreBlurEffect:NO
                                                                          ignoreGesture:NO];
    
    [[MHDismissSharedManager sharedDismissManager]installWithTheme:MHModalThemeWhite
                                                 withIgnoreObjects:@[withoutScroll]];
    return YES;
}
							

@end
