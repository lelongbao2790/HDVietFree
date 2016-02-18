//
//  MainController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "MainController.h"

@interface MainController ()<UITableViewDataSource, UITableViewDelegate, ListMovieByGenreDelegate, FixAutolayoutDelegate>

// Property
@property (strong, nonatomic) NSDictionary *dictMenu;
@property (strong, nonatomic) NSDictionary *dictMovie;
@property (assign, nonatomic) NSInteger lastListMovie;
@property (strong, nonatomic) NSMutableArray *listMovieOnMain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csTrailingConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tbvListMovie;

@end

@implementation MainController

//*****************************************************************************
#pragma mark -
#pragma mark - ** Life Cycle **

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
    // Hidden navigation bar
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **
- (void)configView {
    // Init
    [AppDelegate share].mainController = self;
    self.dictMenu = getDictTitleMenu([MovieSearch share].genreMovie);
    
    [DataManager shared].listMovieDelegate = self;
    self.lastListMovie = 0;
    
    // Config table view
    self.tbvListMovie.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvListMovie.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    // Check list data
    self.listMovieOnMain = [[NSMutableArray alloc] init];
    [self checkListMovie];
    
    [Utilities fixAutolayoutWithDelegate:self];
    [self.tbvListMovie reloadData];
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
    NSArray *arrayKey = [Utilities sortArrayFromDict:self.dictMenu];
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.tag = section;
    headerLabel.userInteractionEnabled = YES;
    headerLabel.backgroundColor = [UIColor colorWithHexString:kBackgroundColorOfSection];
    headerLabel.text = [self.dictMenu objectForKey:arrayKey[section]];
    headerLabel.frame = CGRectMake(0, 0, tableView.tableHeaderView.frame.size.width, tableView.tableHeaderView.frame.size.height);
    headerLabel.textAlignment = NSTextAlignmentCenter;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHeader:)];
    tapGesture.cancelsTouchesInView = NO;
    [headerLabel addGestureRecognizer:tapGesture];
    
    return headerLabel;
    
    //return nil;
}

- (void)didTapHeader:(UITapGestureRecognizer *)recognizer {
    NSInteger section = recognizer.view.tag;
    
    [[DataAccess share] listMovieLocalByTag:[Utilities sortArrayFromDict:self.dictMenu][section]
                                   andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                    andPage:kPageDefault completionBlock:^(BOOL success, NSMutableArray *array) {
                                        if (success) {
                                            FilmController *filmController = [Utilities initFilmControllerWithTag:[Utilities sortArrayFromDict:self.dictMenu][section]
                                                                                                        numberTag:section
                                                                                                        andListDb:array];
                                            [self.navigationController pushViewController:filmController animated:YES];
                                        }
                                    }];
    

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewMoviedentifier];
    if (!cell) {
        cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewMoviedentifier];
    }
    
    [[DataAccess share] listMovieLocalByTag:[Utilities sortArrayFromDict:self.dictMenu][indexPath.section]
                                   andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                    andPage:kPageDefault completionBlock:^(BOOL success, NSMutableArray *array) {
                                        if (success) {
                                            self.listMovieOnMain = [array mutableCopy];
                                            [cell.collectionViewMovie setCollectionViewDataSourceDelegateWithController:kTagMainController
                                                                                                           andListMovie:self.listMovieOnMain];
                                        }
                                    }];
    
    return cell;
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Handle list movie **

- (void)checkListMovie {
    [self.tbvListMovie reloadData];
    DLOG(@"Total menu : %d", (int)self.dictMenu.allKeys.count);
    
    for (int i = 0; i < self.dictMenu.allKeys.count; i++) {
        if ([[DataAccess share] isExistDataMovieWithGenre:stringFromInteger([MovieSearch share].genreMovie) andTag:[Utilities sortArrayFromDict:self.dictMenu][i] andPage:kPageDefault]) {
            // Exist
            [self.tbvListMovie reloadData];
            self.lastListMovie += 1;
            ProgressBarDismissLoading(kEmptyString);
            
        } else {
            ProgressBarShowLoading(kLoading);
            
            // Not exist - Request server to get list
            [[ManageAPI share] loadListMovieAPI:[MovieSearch share].genreMovie tag:[Utilities sortArrayFromDict:self.dictMenu][i] andPage:kPageDefault];
        }
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** List movie delegate **

- (void)loadListMovieAPISuccess:(NSDictionary *)response atTag:(NSString *)tagMovie andGenre:(NSString *)genre {
    DLOG(@"loadListMovieAPISuccess with: %@ %@", tagMovie, genre );
    
    // Add list movie to local
    [[DataAccess share] addListMovieToLocal:response];
    
    // Check last list category
    if ([Utilities isLastListCategory:self.dictMenu andCurrentIndex:self.lastListMovie andLoop:NO]) {
        // Last list loaded
        ProgressBarDismissLoading(kEmptyString);
        [self.tbvListMovie reloadData];
        self.lastListMovie = 0;
    } else {
        self.lastListMovie += 1;
    }
}

- (void)loadListMovieAPIFail:(NSString *)resultMessage {
    [Utilities loadServerFail:self withResultMessage:resultMessage];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {
    self.csLeadingConstraint.constant = kLeadingTableViewMainIphone;
    self.csTrailingConstraint.constant = kTralingTableViewMainIphone;
}

- (void)fixAutolayoutFor40 {
    self.csLeadingConstraint.constant = kLeadingTableViewMainIphone;
    self.csTrailingConstraint.constant = kTralingTableViewMainIphone;
}

- (void)fixAutolayoutFor47 {
    self.csLeadingConstraint.constant = kLeadingTableViewMainIphone;
    self.csTrailingConstraint.constant = kTralingTableViewMainIphone;
}

- (void)fixAutolayoutFor55 {
    self.csLeadingConstraint.constant = kLeadingTableViewMainIphone;
    self.csTrailingConstraint.constant = kTralingTableViewMainIphone;
}

-(void)fixAutolayoutForIpad {
    self.csLeadingConstraint.constant = kLeadingTableViewMainIpad;
    self.csTrailingConstraint.constant = kTralingTableViewMainIpad;
}


@end
