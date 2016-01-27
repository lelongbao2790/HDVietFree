//
//  CollectionMovie.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/26/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CollectionMovie : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>

//*****************************************************************************
#pragma mark -
#pragma mark - ** Property **
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSMutableArray *listMovie;

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **
- (void)setCollectionViewDataSourceDelegate;

@end