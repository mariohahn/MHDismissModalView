//
//  ExampleViewCollectionView.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "ExampleViewCollectionView.h"
#import "ModalViewController.h"
#import "ModalViewControllerWithoutScrollView.h"

#import "UIImage+ImageEffects.h"
#import "UINavigationController+MHDismissModalView.h"

@implementation IVCollectionViewCell

@end
@interface ExampleViewCollectionView ()

@end

@implementation ExampleViewCollectionView


-(void)viewDidLoad{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"View" style:UIBarButtonItemStyleBordered target:self action:@selector(modalPresentationMHWithoutScrollView)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ScrollView" style:UIBarButtonItemStyleBordered target:self action:@selector(modalPresentationMH)];
}
-(void)modalPresentationMHWithoutScrollView{
    ModalViewControllerWithoutScrollView *modal = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalViewControllerWithoutScrollView"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:modal];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)modalPresentationMH{
    ModalViewController *modal = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:modal];
    [self presentViewController:nav animated:YES completion:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{    
    NSString *cellIdentifier = nil;
    cellIdentifier = @"IVCollectionViewCell";
    IVCollectionViewCell *cell = (IVCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row %2  == 0) {
        cell.iv.image = [UIImage imageNamed:@"multitasking_screen_2x"];
    }else{
        cell.iv.image = [UIImage imageNamed:@"itunesradio_mystations_2x"];
    }
    
    return cell;
}


@end
