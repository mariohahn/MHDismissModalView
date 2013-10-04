//
//  ExampleViewCollectionView.m
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import "ExampleViewCollectionView.h"
#import "ModalViewController.h"
#import "UIImage+ImageEffects.h"

@implementation IVCollectionViewCell

@end
@interface ExampleViewCollectionView ()

@end

@implementation ExampleViewCollectionView


-(void)viewDidLoad{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Modal" style:UIBarButtonItemStyleBordered target:self action:@selector(modalPresentationMH)];
}
-(void)modalPresentationMH{
    
    ModalViewController *modal = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalViewController"];
    modal.screenShotImage = [self.navigationController.view screenshotMH];
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
    cell.iv.image = [UIImage imageNamed:@"itunesradio_mystations_2x"];
    return cell;
}


@end
