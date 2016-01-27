//
//  CollectionMovie.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/26/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "CollectionMovie.h"

@implementation CollectionMovie

- (void)setCollectionViewDataSourceDelegate;
{
    DLOG(@"Current section:%d", (int)self.indexPath.section);
    
    [self registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:@"DetailMovieCell"];
    self.dataSource = self;
    self.delegate = self;
    self.listMovie = [[DataAccess share] listMovieLocalByTag:kDicMainMenu.allKeys[self.indexPath.section] andGenre:stringFromInteger([MovieSearch share].genreMovie)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listMovie.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionDetailMovieIdentifier forIndexPath:indexPath];
    if([indexPath row] == self.listMovie.count - 1){
        //end of loading
        //for example [activityIndicator stopAnimating];
    } else {
        [cell loadInformationWithMovie:self.listMovie[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
