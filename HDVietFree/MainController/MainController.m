//
//  MainController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "MainController.h"

@interface MainController ()<UITableViewDataSource, UITableViewDelegate, ListMovieByGenreDelegate>

// Property
@property (strong, nonatomic) NSDictionary *dictMenu;
@property (strong, nonatomic) NSDictionary *dictMovie;
@property (assign, nonatomic) NSInteger lastListMovie;

// IBOutlet
@property (weak, nonatomic) IBOutlet UITableView *tbvListMovie;

@end

@implementation MainController

//*****************************************************************************
#pragma mark -
#pragma mark - ** Life Cycle **

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // Hidden navigation bar
    [self.navigationController.navigationBar setHidden:NO];
    [self configView];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **
- (void)configView {
    // Init
    self.dictMenu = kDicMainMenu;
    self.title = @"PHIM LẺ";
    [DataManager shared].listMovieDelegate = self;
    self.lastListMovie = 0;
    
    // Config table view
    self.tbvListMovie.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvListMovie.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Check list data
    [self checkListMovie];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Table view delegate **

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dictMenu.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.dictMenu.allValues[section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithHexString:kBackgroundColorOfSection];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    header.textLabel.font = [UIFont systemFontOfSize:14];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewMoviedentifier];
    if (!cell) {
        cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewMoviedentifier];
    }
    
    // Config cell
    cell.collectionViewMovie.indexPath = indexPath;
    [cell.collectionViewMovie setCollectionViewDataSourceDelegate];
    return cell;
    
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Handle list movie **

- (void)checkListMovie {
    
    DLOG(@"Total menu : %d", (int)kDicMainMenu.allKeys.count);
    
    for (int i = 0; i < kDicMainMenu.allKeys.count; i++) {
        if ([[DataAccess share] isExistDataMovieWithGenre:stringFromInteger([MovieSearch share].genreMovie) andTag:kDicMainMenu.allKeys[i]]) {
            // Exist
            [self.tbvListMovie reloadData];
            
        } else {
            ProgressBarShowLoading(kLoading);
            
            // Not exist - Request server to get list
            [[ManageAPI share] loadListMovieAPI:[MovieSearch share].genreMovie tag:kDicMainMenu.allKeys[i] andPage:kPageDefault];
        }
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** List movie delegate **

- (void)loadListMovieAPISuccess:(NSDictionary *)response atTag:(NSString *)tagMovie andGenre:(NSString *)genre {
    DLOG(@"loadListMovieAPISuccess with: %@ %@", tagMovie, genre );
    DLOG(@"Last list movie : %d", (int)self.lastListMovie);
    
    // Get list movie from response
    NSArray *listData = [response objectForKey:kList];
    
    // Get detail movie and init object movie
    for (NSDictionary *dictObjectMovie in listData) {
        [Movie detailListMovieFromJSON:dictObjectMovie withTag:tagMovie andGenre:genre];
    }
    
    if (self.lastListMovie == kDicMainMenu.allKeys.count - 1) {
        // Last list loaded
        ProgressBarDismissLoading(kEmptyString);
        [self.tbvListMovie reloadData];
        self.lastListMovie = 0;
        
    } else {
        self.lastListMovie += 1;
    }
}

- (void)loadListMovieAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmptyString);
    [Utilities showiToastMessage:resultMessage];
    
}


@end
