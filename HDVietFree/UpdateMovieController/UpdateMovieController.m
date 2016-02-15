//
//  UpdateMovieController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/15/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "UpdateMovieController.h"

@interface UpdateMovieController ()<ListMovieByGenreDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbTotalMovie;
@property (assign, nonatomic) NSInteger lastListMovie;
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

- (IBAction)btnUpdate:(id)sender {
    
    [self requestUpdateMovie];
}

/*
 * Config view
 */
- (void)configView {
    [self updateTotalMovie];
    [DataManager shared].listMovieDelegate = self;
}

/*
 * Update label movie
 */
- (void)updateTotalMovie {
    self.lbTotalMovie.text = stringFromInteger([[Movie query] count]);
}

- (void)requestUpdateMovie {
    [[[Movie query] fetch] removeAll];
    self.lastListMovie = 0;
    DLOG(@"Total menu : %d", (int)kDicMainMenu.allKeys.count);
    ProgressBarShowLoading(kLoading);
    
    for (int i = 0; i < kDicMainMenu.allKeys.count; i++) {
        // Not exist - Request server to get list
        [[ManageAPI share] loadListMovieAPI:kGenrePhimLe tag:kDicMainMenu.allKeys[i] andPage:kPageDefault];
        [[ManageAPI share] loadListMovieAPI:kGenrePhimBo tag:kDicMainMenu.allKeys[i] andPage:kPageDefault];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** List movie delegate **

- (void)loadListMovieAPISuccess:(NSDictionary *)response atTag:(NSString *)tagMovie andGenre:(NSString *)genre {
    
    
    // Get list movie from response
    NSArray *listData = [response objectForKey:kList];
    NSInteger totalRecord = [[[response objectForKey:kMetadata] objectForKey:kTotalRecord] integerValue];
    NSInteger pageResponse = [[[response objectForKey:kMetadata] objectForKey:kPage] integerValue];
    NSInteger genreNumber = [[[response objectForKey:kMetadata] objectForKey:kGenre] integerValue];
    DLOG(@"loadListMovieAPISuccess with: %@ %d", tagMovie, (int)genreNumber );
    
    // Get detail movie and init object movie
    for (NSDictionary *dictObjectMovie in listData) {
        Movie *newMovie = [Movie detailListMovieFromJSON:dictObjectMovie withTag:tagMovie andGenre:stringFromInteger(genreNumber)];
        newMovie.pageNumber = pageResponse;
        newMovie.totalRecord = totalRecord;
        [newMovie commit];
    }
    
    if (self.lastListMovie == kDicMainMenu.allKeys.count*2 - 1) {
        // Last list loaded
        ProgressBarDismissLoading(kEmptyString);
        self.lastListMovie = 0;
        [Utilities showiToastMessage:kUpdateMovieSuccess];
        [self updateTotalMovie];
    } else {
        self.lastListMovie += 1;
    }
    
}

- (void)loadListMovieAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmptyString);
    [Utilities showiToastMessage:resultMessage];
    // Remove access token save
    
}

@end
