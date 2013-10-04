//
//  ExampleViewCollectionView.h
//  MHDismissModalView
//
//  Created by Mario Hahn on 04.10.13.
//  Copyright (c) 2013 Mario Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IVCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)IBOutlet UIImageView *iv;
@end

@interface ExampleViewCollectionView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)IBOutlet UICollectionView *collectionView;
@end
