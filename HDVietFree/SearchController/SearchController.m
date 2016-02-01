//
//  SearchController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/1/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "SearchController.h"

@interface SearchController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, SearchMovieDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbvSearch;
@property (nonatomic, strong) DBEventHandler* recipeEventHandler;
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *listResult;

@end

@implementation SearchController

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

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **
- (void)configView {
    [DataManager shared].searchMovieDelegate = self;
    self.listResult = [[NSMutableArray alloc] init];
    [self initData];
    self.title = kSearchMovieTitle;
    
    // Config table view recipe
    self.tbvSearch.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvSearch.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Init search controller
    [self initSearchController];
}

- (void) initData {
    /* get the event object for the MacModel class object */
    self.recipeEventHandler = [Movie eventHandler];
    
    [self.recipeEventHandler registerBlockForEvents:DBAccessEventDelete |DBAccessEventInsert |DBAccessEventUpdate
                                          withBlock:^(DBEvent *event) {
                                              [self.tbvSearch reloadData];
                                          } onMainThread:YES];
}

/*
 * Init search controller
 */
- (void)initSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = kSearchMovie;
    self.tbvSearch.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.barTintColor = [UIColor colorWithHexString:kColorBgNavigationBar];
    self.definesPresentationContext = YES;
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Table view delegate **

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listResult count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Init cell
    SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:kSearchCellIdentifier];
    if (!cell) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchCellIdentifier];
    }

    [cell loadInformationWithMovie:self.listResult[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayController *playController = InitStoryBoardWithIdentifier(kPlayController);
    playController.movie = self.listResult[indexPath.row];
    [self.navigationController pushViewController:playController animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) { [tableView setSeparatorInset:UIEdgeInsetsZero]; }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) { [tableView setLayoutMargins:UIEdgeInsetsZero]; }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { [cell setLayoutMargins:UIEdgeInsetsZero]; }
}
#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    
    // Filter content
    [[ManageAPI share] searchMovieWithKeyword:searchString];
    
}

#pragma mark - Search movie delegate
- (void)searchMovieAPISuccess:(NSDictionary *)response {
    [self.listResult removeAllObjects];
    NSArray *docs = [response objectForKey:kDocs];
    for (NSDictionary *dictMovie in docs) {
        Movie *newMovie = [Movie initMovieFromJSONSearch:dictMovie];
        [self.listResult addObject:newMovie];
    }
    [self.tbvSearch reloadData];
}

- (void)searchMovieAPIFail:(NSString *)resultMessage {
    [Utilities showiToastMessage:resultMessage];
}


@end
