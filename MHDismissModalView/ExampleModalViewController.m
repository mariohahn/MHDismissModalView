//
//  ExampleModalViewController.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "ExampleModalViewController.h"
#import "ExampleViewCollectionView.h"

@implementation TestCell

@end
@interface ExampleModalViewController ()

@end

@implementation ExampleModalViewController

-(void)viewDidLoad{
    
    self.title = @"Modal view with a scrollView";
    
//    [self.navigationController installMHDismissModalViewWithOptions:[[MHDismissModalViewOptions alloc] initWithScrollView:self.tableView
//                                                                                                                    theme:MHModalThemeWhite]];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
    cell.labelText.text = [NSString stringWithFormat:@"Row %li",(long)indexPath.row];
    cell.labelText.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExampleViewCollectionView *example = [self.storyboard instantiateViewControllerWithIdentifier:@"ExampleViewCollectionView"];
    [self.navigationController pushViewController:example animated:YES];
    
}


@end
