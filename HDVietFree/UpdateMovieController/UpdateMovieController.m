//
//  UpdateMovieController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/15/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "UpdateMovieController.h"

@interface UpdateMovieController ()<ListMovieByGenreDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbTotalMovie;
@property (weak, nonatomic) IBOutlet UILabel *lbNumberMovieUpdate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionMovieUpdate;
@property (strong, nonatomic) NSMutableArray *listMovieUpdate;
@property (strong, nonatomic) NSArray *listOldMovie;
@property (assign, nonatomic) NSInteger lastListMovie;
@property (strong, nonatomic) NSDictionary *dictMenu;
@end

@implementation UpdateMovieController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [DataManager shared].listMovieDelegate = self;
    self.collectionMovieUpdate.delegate = self;
    self.collectionMovieUpdate.dataSource = self;
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

/*
 * Config view
 */
- (void)configView {
    [self updateTotalMovie];
    
    self.title = [kUpdateData uppercaseString];
    self.dictMenu = getDictTitleMenu([MovieSearch share].genreMovie);
    self.listMovieUpdate = [[NSMutableArray alloc] init];
}

/*
 * Update label movie
 */
- (void)updateTotalMovie {
    self.lbTotalMovie.text = stringFromInteger([[Movie query] count]);
    
    // Compare old and new movie
    [self compareOldAndNewMovie];
}

- (void)requestUpdateMovie {
    ProgressBarShowLoading(kLoading);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // Download
        self.listOldMovie = [[DataAccess share] getAllMovie];
        [[[Movie query] fetch] removeAll];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.lastListMovie = 0;
            DLOG(@"Total menu : %d", (int)kDicMainMenu.allKeys.count);
            
            for (int i = 0; i < self.dictMenu.allKeys.count; i++) {
                // Not exist - Request server to get list
                [[ManageAPI share] loadListMovieAPI:kGenrePhimLe tag:self.dictMenu.allKeys[i] andPage:kPageDefault];
                [[ManageAPI share] loadListMovieAPI:kGenrePhimBo tag:self.dictMenu.allKeys[i] andPage:kPageDefault];
            }
        });
    });
}

- (IBAction)btnUpdate:(id)sender {
    
    // Reset list movie
    [self.listMovieUpdate removeAllObjects];
    [self.collectionMovieUpdate reloadData];
    
    [self requestUpdateMovie];
}

- (BOOL)isOldMovie:(Movie *)movie {
    BOOL isOld = false;
    for (Movie *oldMovie in self.listOldMovie) {
        if ([oldMovie.movieID isEqualToString:movie.movieID]) {
            isOld = true;
            break;
        } else {
            isOld = false;
        }
    }
    return isOld;
}

- (void)compareOldAndNewMovie {
    
    NSArray *listNewMovie = [[[DataAccess share] getAllMovie] mutableCopy];
    
    for(int i = 0;i<[listNewMovie count];i++)
    {
        if (![self isOldMovie:[listNewMovie objectAtIndex:i]]) {
             [self.listMovieUpdate addObject:[listNewMovie objectAtIndex:i]];
        }
    }

    self.lbNumberMovieUpdate.text = stringFromInteger(self.listMovieUpdate.count);
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listMovieUpdate.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    DetailMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionDetailMovieIdentifier forIndexPath:indexPath];
    cell.typeCell = kTypeFilm;
    [cell loadInformationWithMovie:self.listMovieUpdate[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayController *playController = InitStoryBoardWithIdentifier(kPlayController);
    playController.movie = self.listMovieUpdate[indexPath.row];
    [self.navigationController pushViewController:playController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeZero;
    
    if (kDeviceIsPhoneSmallerOrEqual35) returnSize = sizeCellFilmIp5; else if (kDeviceIsPhoneSmallerOrEqual40) returnSize = sizeCellFilmIp5;
    else if (kDeviceIsPhoneSmallerOrEqual47) returnSize = sizeCellFilmIp6; else if (kDeviceIsPhoneSmallerOrEqual55) returnSize = sizeCellFilmIp6Plus;
    else if (kDeviceIpad) returnSize = sizeCellFilmIp6;
    return returnSize;
}


//*****************************************************************************
#pragma mark -
#pragma mark - ** List movie delegate **

- (void)loadListMovieAPISuccess:(NSDictionary *)response atTag:(NSString *)tagMovie andGenre:(NSString *)genre {
    
    // Add list movie to local
    [[DataAccess share] addListMovieToLocal:response];
    
    // Check last list category
    if ([Utilities isLastListCategory:self.dictMenu andCurrentIndex:self.lastListMovie andLoop:YES]) {
        // Last list loaded
        self.lastListMovie = 0;
        [Utilities showiToastMessage:kUpdateMovieSuccess];
        [self updateTotalMovie];
        ProgressBarDismissLoading(kEmptyString);
        
        [self.collectionMovieUpdate reloadData];
        
    } else {
        self.lastListMovie += 1;
    }
}

- (void)loadListMovieAPIFail:(NSString *)resultMessage {
    [Utilities loadServerFail:self withResultMessage:resultMessage];
}

@end
