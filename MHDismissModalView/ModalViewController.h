//
//  ModalViewController.h
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+MHDismissModalView.h"

@interface TestCell : UITableViewCell
@property (nonatomic,strong)IBOutlet UILabel *labelText;
@end

@interface ModalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIView *oldView;
@property(nonatomic,strong) UIImageView *bluredView;
@property(nonatomic,strong) UIImage *screenShotImage;

@end
