//
//  CollectionMovie.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/26/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "CollectionMovie.h"

@implementation CollectionMovie

- (void)awakeFromNib {
    
}

- (void)setCollectionViewDataSourceDelegateWithController:(NSInteger)typeController andListMovie:(NSArray *)listMovieInDB
{
    self.listMovie = listMovieInDB;
    [self registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:kDetailMovieCell];
    self.dataSource = self;
    self.delegate = self;
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
