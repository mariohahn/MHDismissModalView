//
//  ExampleModalViewWithoutScrollViewController.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 07.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "ExampleModalViewWithoutScrollViewController.h"
#import "UINavigationController+MHDismissModalView.h"

@interface ExampleModalViewWithoutScrollViewController ()

@end

@implementation ExampleModalViewWithoutScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Modal view without a scrollView";    
//    [self.navigationController installMHDismissModalViewWithOptions:[[MHDismissModalViewOptions alloc] initWithScrollView:nil
//                                                                                                                    theme:MHModalThemeWhite]];
}


@end
