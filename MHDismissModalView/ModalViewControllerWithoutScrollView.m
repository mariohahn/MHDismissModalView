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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.navigationController installMHDismissModalViewWithOptions:[[MHDismissModalViewOptions alloc] initWithScrollView:nil
                                                                                                                    theme:MHModalThemeWhite]];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
