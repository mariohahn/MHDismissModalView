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
    

    
    [[MHDismissSharedManager sharedDismissManager] installWithTheme:MHModalThemeWhite
                                                     withIgnorBlock:^(MHDismissIgnore *ignore) {
                                                         if ([ignore.viewControllerName isEqualToString:@"ExampleModalViewController"]) {
                                                             ignore.ignoreBlurEffect = YES;
                                                         }
                                                     }];
    return YES;
}


@end
