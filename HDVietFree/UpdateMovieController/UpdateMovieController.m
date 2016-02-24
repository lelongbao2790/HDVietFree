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



//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

/*
 * Config view
 */
- (void)configView {
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kBackgroundImage]]];
    [self updateTotalMovie];
    [DataManager shared].listMovieDelegate = self;
    self.title = [kUpdateData uppercaseString];
     self.dictMenu = getDictTitleMenu([MovieSearch share].genreMovie);
}

/*
 * Update label movie
 */
- (void)updateTotalMovie {
    self.lbTotalMovie.text = stringFromInteger([[Movie query] count]);
}

- (void)requestUpdateMovie {
    ProgressBarShowLoading(kLoading);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // Download
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
    
    [self requestUpdateMovie];
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
        ProgressBarDismissLoading(kEmptyString);
        self.lastListMovie = 0;
        [Utilities showiToastMessage:kUpdateMovieSuccess];
        [self updateTotalMovie];
    } else {
        self.lastListMovie += 1;
    }
}

- (void)loadListMovieAPIFail:(NSString *)resultMessage {
    [Utilities loadServerFail:self withResultMessage:resultMessage];
}

@end
