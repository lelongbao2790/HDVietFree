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
    [AppDelegate share].mainController = self;
    self.dictMenu = kDicMainMenu;
    [DataManager shared].listMovieDelegate = self;
    self.lastListMovie = 0;
//    [self initSearchBarButton];
    
    // Config table view
    self.tbvListMovie.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvListMovie.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    // Check list data
    [self checkListMovie];
}

- (void)initSearchBarButton {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:kSearchIcon] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButton)];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)searchBarButton {
    SearchController *searchController = InitStoryBoardWithIdentifier(kSearchController);
    [self.navigationController pushViewController:searchController animated:YES];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Table view delegate **

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dictMenu.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.tag = section;
    headerLabel.userInteractionEnabled = YES;
    headerLabel.backgroundColor = [UIColor colorWithHexString:kBackgroundColorOfSection];
    headerLabel.text = self.dictMenu.allValues[section];
    headerLabel.frame = CGRectMake(0, 0, tableView.tableHeaderView.frame.size.width-100, tableView.tableHeaderView.frame.size.height);
    
    UILabel *dotLabel = [[UILabel alloc]init];
    dotLabel.text = @"...";
    dotLabel.frame = CGRectMake(tableView.tableHeaderView.frame.size.width - 100, 0, 100, tableView.tableHeaderView.frame.size.height);
    
    [headerLabel addSubview:dotLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHeader:)];
    tapGesture.cancelsTouchesInView = NO;
    [headerLabel addGestureRecognizer:tapGesture];
    
    return headerLabel;
    
    //return nil;
}

- (void)didTapHeader:(UITapGestureRecognizer *)recognizer {
    NSInteger section = recognizer.view.tag;
    NSArray *listDBInLocal = [[DataAccess share] listMovieLocalByTag:kDicMainMenu.allKeys[section]
                                                            andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                                             andPage:kPageDefault];
    FilmController *filmController = InitStoryBoardWithIdentifier(kFilmController);
    filmController.view.tag = section;
    filmController.listMovie = [[NSMutableArray alloc] initWithArray:listDBInLocal];
    [self.navigationController pushViewController:filmController animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewMoviedentifier];
    if (!cell) {
        cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewMoviedentifier];
    }
    
    // Config cell
    NSArray *listDBInLocal = [[DataAccess share] listMovieLocalByTag:kDicMainMenu.allKeys[indexPath.section]
                                                            andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                                             andPage:kPageDefault];
    
    [cell.collectionViewMovie setCollectionViewDataSourceDelegateWithController:kTagMainController
                                                                   andListMovie:listDBInLocal];
    return cell;
    
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Handle list movie **

- (void)checkListMovie {
    
    DLOG(@"Total menu : %d", (int)kDicMainMenu.allKeys.count);
    
    for (int i = 0; i < kDicMainMenu.allKeys.count; i++) {
        if ([[DataAccess share] isExistDataMovieWithGenre:stringFromInteger([MovieSearch share].genreMovie) andTag:kDicMainMenu.allKeys[i] andPage:kPageDefault]) {
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
    
    // Get list movie from response
    NSArray *listData = [response objectForKey:kList];
    NSInteger totalRecord = [[[response objectForKey:kMetadata] objectForKey:kTotalRecord] integerValue];
    
    // Get detail movie and init object movie
    for (int i = 0; i < listData.count; i++) {
        NSDictionary *dictObjectMovie = listData[i];
        Movie *newMovie = [Movie detailListMovieFromJSON:dictObjectMovie withTag:tagMovie andGenre:genre];
        newMovie.pageNumber = kPageDefault;
        newMovie.totalRecord = totalRecord;
        [newMovie commit];
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
    // Remove access token save
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
    
}

@end
