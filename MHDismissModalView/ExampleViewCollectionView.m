//
//  ExampleViewCollectionView.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "ExampleViewCollectionView.h"
#import "ExampleModalViewController.h"
#import "ExampleModalViewWithoutScrollViewController.h"
#import "UIImage+ImageEffects.h"
#import "UINavigationController+MHDismissModalView.h"

@implementation IVCollectionViewCell

@end
@interface ExampleViewCollectionView ()

@end

@implementation ExampleViewCollectionView

-(void)viewDidLoad{
    
    if (self.navigationController.viewControllers.count ==1) {
        self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithTitle:@"ScrollView" style:UIBarButtonItemStyleBordered target:self action:@selector(modalPresentationMH)],[[UIBarButtonItem alloc]initWithTitle:@"View" style:UIBarButtonItemStyleBordered target:self action:@selector(modalPresentationMHWithoutScrollView)]];

        
    }
}



-(void)modalPresentationMHWithoutScrollView{
    ExampleModalViewWithoutScrollViewController *modal = [self.storyboard instantiateViewControllerWithIdentifier:@"ExampleModalViewWithoutScrollViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:modal];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)modalPresentationMH{
    ExampleModalViewController *modal = [self.storyboard instantiateViewControllerWithIdentifier:@"ExampleModalViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:modal];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{    
    NSString *cellIdentifier = nil;
    cellIdentifier = @"IVCollectionViewCell";
    IVCollectionViewCell *cell = (IVCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row %3  == 0) {
        cell.iv.image = [UIImage imageNamed:@"multitasking_screen_2x"];
    }else if(indexPath.row % 2  ==0){
        cell.iv.image = [UIImage imageNamed:@"photos_moments_screen_2x"];
    }else{
        cell.iv.image = [UIImage imageNamed:@"itunesradio_mystations_2x"];
    }
    
    return cell;
}


@end
