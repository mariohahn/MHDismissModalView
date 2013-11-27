//
//  ExampleModalViewWithoutScrollViewController.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 07.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "ExampleModalViewWithoutScrollViewController.h"
#import "UINavigationController+MHDismissModalView.h"
#import "ExampleModalViewController.h"

@interface ExampleModalViewWithoutScrollViewController ()

@end

@implementation ExampleModalViewWithoutScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Modal view without a scrollView";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"present" style:UIBarButtonItemStyleBordered target:self action:@selector(presentAgain)];
//    [self.navigationController installMHDismissModalViewWithOptions:[[MHDismissModalViewOptions alloc] initWithScrollView:nil
//                                                                                                                    theme:MHModalThemeWhite]];
}
-(void)presentAgain{
    ExampleModalViewController *modal = [self.storyboard instantiateViewControllerWithIdentifier:@"ExampleModalViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:modal];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

@end
