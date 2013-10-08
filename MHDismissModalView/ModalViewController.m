//
//  ModalViewController.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "ModalViewController.h"

@implementation TestCell

@end
@interface ModalViewController ()

@end

@implementation ModalViewController

-(void)viewDidLoad{
    
    self.title = @"Modal view with a scrollView";
    
    
    
//    [self.navigationController installMHDismissModalViewWithOptions:[[MHDismissModalViewOptions alloc] initWithScrollView:self.tableView
//                                                                                                                    theme:MHModalThemeWhite]];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
    cell.labelText.text = [NSString stringWithFormat:@"Row %li",(long)indexPath.row];
    cell.labelText.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    return cell;
}


@end
