//
//  FilmController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/1/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "FilmController.h"

@interface FilmController ()<ListMovieByGenreDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign, nonatomic) NSInteger totalItemOnOnePage;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionFilmController;

@end

@implementation FilmController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [DataManager shared].listMovieDelegate = self;
    [self.collectionFilmController registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:kDetailMovieCell];
    [self.collectionFilmController reloadData];
    self.collectionFilmController.delegate = self;
    self.collectionFilmController.dataSource = self;
    self.totalItemOnOnePage = self.listMovie.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    if (cell == nil) {
        DLOG(@"Cell nil");
    }
    [cell loadInformationWithMovie:self.listMovie[indexPath.row]];
    
    // Load more row when scroll on last row
    DLOG(@"Row : %d", (int)indexPath.row);
    
//    NSInteger numberOfItemPerRow = (NSInteger)([Utilities widthOfScreen] /
//                                               [self collectionView:collectionView
//                                                             layout:collectionView.collectionViewLayout
//                                             sizeForItemAtIndexPath:indexPath].width);
//    NSInteger lastRow = (self.listMovie.count / numberOfItemPerRow);
    
    // Check last item
    if(indexPath.item == (self.listMovie.count - 1)) {
        // Load more item when scroll to last item
        [self checkListMovie];
    }
    
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

//*****************************************************************************
#pragma mark -
#pragma mark - ** Handle list movie **

- (void)checkListMovie {
    
    Movie *randomMovie = self.listMovie[0];
    if (self.listMovie.count < randomMovie.totalRecord + 1) {
        NSInteger nextPage = (self.listMovie.count / self.totalItemOnOnePage) + 1;
        
        if ([[DataAccess share] isExistDataMovieWithGenre:stringFromInteger([MovieSearch share].genreMovie)
                                                   andTag:kDicMainMenu.allKeys[self.view.tag]
                                                  andPage:nextPage]) {
            // Exist
            DLOG(@"Get list movie of next page from local:%d",(int)nextPage);
            [self refreshListMovieWithPage:nextPage];
            
        } else {
            // Not exist - Request server to get list
            [[ManageAPI share] loadListMovieAPI:[MovieSearch share].genreMovie
                                            tag:kDicMainMenu.allKeys[self.view.tag]
                                        andPage:nextPage];
        }
    }
}

- (void)requestGetListMovie:(NSNumber *)nextPage {
    [[ManageAPI share] loadListMovieAPI:[MovieSearch share].genreMovie
                                    tag:kDicMainMenu.allKeys[self.view.tag]
                                andPage:[nextPage integerValue]];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** List movie delegate **

- (void)loadListMovieAPISuccess:(NSDictionary *)response atTag:(NSString *)tagMovie andGenre:(NSString *)genre {
    DLOG(@"loadListMovieAPISuccess with: %@ %@", tagMovie, genre );
    
    // Fixed crash of next page is same of previous page
    NSInteger nextPage = (self.listMovie.count / self.totalItemOnOnePage) + 1;
    
    // Get list movie from response
    NSArray *listData = [response objectForKey:kList];
    NSInteger totalRecord = [[[response objectForKey:kMetadata] objectForKey:kTotalRecord] integerValue];
    
    // Get detail movie and init object movie
    for (int i = 0; i < listData.count; i++) {
        NSDictionary *dictObjectMovie = listData[i];
        Movie *newMovie = [Movie detailListMovieFromJSON:dictObjectMovie withTag:tagMovie andGenre:genre];
        newMovie.pageNumber = nextPage;
        newMovie.totalRecord = totalRecord;
        [newMovie commit];
    }
    
    [self refreshListMovieWithPage:nextPage];
}

- (void)loadListMovieAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmptyString);
    [Utilities showiToastMessage:resultMessage];
}

/*
 * Refresh list movie
 */
- (void)refreshListMovieWithPage:(NSInteger)page {
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSInteger totalCount = [self.listMovie count];
    NSArray *listMovieForPage = [[DataAccess share] listMovieLocalByTag:kDicMainMenu.allKeys[self.view.tag]
                                                               andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                                                andPage:page];
    for (int i = 0; i < listMovieForPage.count; i++) {
        Movie *newMovie = listMovieForPage[i];
        [self.listMovie addObject:newMovie];
        [indexPaths addObject:[NSIndexPath indexPathForRow:totalCount + i
                                                 inSection:0]];
    }
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    } completion:nil];
}

@end
