//
//  ModalViewControllerWithoutScrollView.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 07.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "ModalViewControllerWithoutScrollView.h"
#import "UINavigationController+MHDismissModalView.h"

@interface ModalViewControllerWithoutScrollView ()

@end

@implementation ModalViewControllerWithoutScrollView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Modal view without a scrollView";    
//    [self.navigationController installMHDismissModalViewWithOptions:[[MHDismissModalViewOptions alloc] initWithScrollView:nil
//                                                                                                                    theme:MHModalThemeWhite]];
}


@end
