//
//  CollectionMovie.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/26/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "CollectionMovie.h"

@interface CollectionMovie ()

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end
@implementation CollectionMovie

/*
 * Use awake from nib when init some thing in one time.
 */
-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:kDetailMovieCell];
    self.dataSource = self;
    self.delegate = self;
}

- (void)setListMovieDb:(NSArray *)listMovieInDB
{
    // Lag in here
    self.listMovie = listMovieInDB;
    [self reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listMovie.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionDetailMovieIdentifier forIndexPath:indexPath];
    [cell loadInformationWithMovie:self.listMovie[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayController *playController = nil;
    if (kPlayViewController) {
        playController = kPlayViewController;
        [playController resetView];
        playController.movie = self.listMovie[indexPath.row];
        [playController getInformationMovie];
    } else {
        playController = InitStoryBoardWithIdentifier(kPlayController);
        playController.movie = self.listMovie[indexPath.row];
        [[AppDelegate share].mainController.navigationController pushViewController:playController animated:YES];
    }
}

@end
