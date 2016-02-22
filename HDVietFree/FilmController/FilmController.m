//
//  FilmController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/1/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "FilmController.h"

@interface FilmController ()<ListMovieByGenreDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionFilmController;
@property (assign, nonatomic) NSInteger previousPage;
@end

@implementation FilmController
//*****************************************************************************
#pragma mark -
#pragma mark - ** Life Cycle **

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

- (void)configView {
    // Init
    [DataManager shared].listMovieDelegate = self;
    [self.collectionFilmController registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:kDetailMovieCell];
    [self.collectionFilmController reloadData];
    
    // Check request list movie
    [self requestListMovieFromLocal];
    
    if (self.previousPage) {
        
    } else {
        self.previousPage = 1;
    }
}

- (void)requestListMovieFromLocal {
    if ([Utilities isEmptyArray:self.listMovie]) {
        
        // Load first page
        ProgressBarShowLoading(kLoading);
        [self requestGetListMovie:kPageDefault];
    }
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
    
    [cell loadInformationWithMovie:self.listMovie[indexPath.row]];
    
    DLOG(@"Row : %d", (int)indexPath.row);
    // Check last item
    DLOG(@"Last item : %d", (int)indexPath.item);
    if(indexPath.item == (self.listMovie.count - 1)) {
        [self checkListMovie];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayController *playController = InitStoryBoardWithIdentifier(kPlayController);
    playController.movie = self.listMovie[indexPath.row];
    [self.navigationController pushViewController:playController animated:YES];
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
        returnSize = sizeCellFilmIp6Plus;
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
        DLOG(@"Get list movie of next page :%d",(int)nextPage);
        
        // Check exist data
        [[DataAccess share] checkExistDataMovieWithGenre:stringFromInteger([MovieSearch share].genreMovie) andTag:self.tagMovie andPage:nextPage completionBlock:^(BOOL success, NSMutableArray *array) {
            if (success) {
                // Exist
                [self refreshListMovieWithPage:nextPage];
            } else {
                // Not exist - Request server to get list
                [self requestGetListMovie:nextPage];
            }
        }];
    }
}

- (void)requestGetListMovie:(NSInteger)nextPage {
    [[ManageAPI share] loadListMovieAPI:[MovieSearch share].genreMovie
                                    tag:self.tagMovie
                                andPage:nextPage];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** List movie delegate **

- (void)loadListMovieAPISuccess:(NSDictionary *)response atTag:(NSString *)tagMovie andGenre:(NSString *)genre {
    ProgressBarDismissLoading(kEmptyString);
    
    if (response.count > 0) {
        DLOG(@"loadListMovieAPISuccess with: %@ %d", tagMovie, (int)numberToInteger(dictToArray(response)[kPageResponsePosition]));
        
        // Add list movie to local
        [[DataAccess share] addListMovieToLocal:response];
        
        [self refreshListMovieWithPage:numberToInteger(dictToArray(response)[kPageResponsePosition])];
    }
}

- (void)loadListMovieAPIFail:(NSString *)resultMessage {
    [Utilities loadServerFail:self withResultMessage:resultMessage];
}

/*
 * Refresh list movie
 */
- (void)refreshListMovieWithPage:(NSInteger)page {

    if (self.previousPage != page) {
        [self addNextListMovie:page];
        
    } else {
        if (self.listMovie.count == 0) {
            [self addNextListMovie:page];
        }
    }
}

- (void)addNextListMovie:(NSInteger)page {
    
    // Init and get db in local
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSInteger totalCount = [self.listMovie count];
    
    // Using GCD to get list db local
    [[DataAccess share] listMovieLocalByTag:self.tagMovie
                                   andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                    andPage:page completionBlock:^(BOOL success, NSMutableArray *array) {
                                        
                                        if (success) {
                                            
                                            // Assign total item if list is empty
                                            if ([Utilities isEmptyArray:self.listMovie]) {
                                                self.totalItemOnOnePage = array.count;
                                                self.previousPage = 1;
                                            }

                                             // Add object to current list and refresh
                                            for (int i = 0; i < array.count; i++) {
                                                
                                                Movie *newMovie = array[i];
                                                [self.listMovie addObject:newMovie];
                                                [indexPaths addObject:[NSIndexPath indexPathForItem:totalCount + i inSection:0]];
                                            }
                                            
                                            [self.collectionView performBatchUpdates:^{
                                                [self.collectionView insertItemsAtIndexPaths:indexPaths];
                                            } completion:nil];
                                            
                                            self.previousPage = page;
                                        }
                                    }];

}

@end
