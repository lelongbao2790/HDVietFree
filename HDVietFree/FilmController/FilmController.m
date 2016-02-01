//
//  FilmController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/1/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "FilmController.h"

@interface FilmController ()

@end

@implementation FilmController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    self.title = kDicMainMenu.allValues[self.view.tag];
    [self.collectionView registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:kDetailMovieCell];
    [self.collectionView reloadData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listMovie.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    DetailMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionDetailMovieIdentifier forIndexPath:indexPath];
    [cell loadInformationWithMovie:self.listMovie[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayController *playController = InitStoryBoardWithIdentifier(kPlayController);
    playController.movie = self.listMovie[indexPath.row];
    [[AppDelegate share].mainController.navigationController pushViewController:playController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeZero;
    
    if (kDeviceIsPhoneSmallerOrEqual35) {
        returnSize = sizeCellFilmIp5;
    } else if (kDeviceIsPhoneSmallerOrEqual40) {
        returnSize = sizeCellFilmIp5;
    } else if (kDeviceIsPhoneSmallerOrEqual47) {
        returnSize = sizeCellFilmIp6;
    } else if (kDeviceIsPhoneSmallerOrEqual55) {
        returnSize = sizeCellFilmIp6;
    } else if (kDeviceIpad) {
        returnSize = sizeCellFilmIp6;
    }
    return returnSize;
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
