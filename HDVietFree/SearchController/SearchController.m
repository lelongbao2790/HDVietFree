//
//  SearchController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/1/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "SearchController.h"

@interface SearchController ()<UITableViewDataSource, UITableViewDelegate, SearchMovieDelegate, UITextFieldDelegate>
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

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewWillDisappear:(BOOL)animated {
    NavigationMovieCustomController *navCustom = (NavigationMovieCustomController *)self.navigationController;
    navCustom.searchController = nil;
    [self dismissView];
    
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

- (void)dismissView {
    [self.navigationController.view endEditing:YES];
}

- (void)configView {
    [DataManager shared].searchMovieDelegate = self;
    self.listResult = [[NSMutableArray alloc] init];
    [self initData];
    
    // Config table view recipe
    self.tbvSearch.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvSearch.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void) initData {
    /* get the event object for the MacModel class object */
    self.recipeEventHandler = [Movie eventHandler];
    
    [self.recipeEventHandler registerBlockForEvents:DBAccessEventDelete |DBAccessEventInsert |DBAccessEventUpdate
                                          withBlock:^(DBEvent *event) {
                                              [self.tbvSearch reloadData];
                                          } onMainThread:YES];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Text field delegate **
-(void)textDidChange:(NSNotification *)notification {
    UITextField *searchText = [notification object];
    [[ManageAPI share] searchMovieWithKeyword:searchText.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
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
    [self dismissView];
    
    PlayController *playController = InitStoryBoardWithIdentifier(kPlayController);
    playController.movie = self.listResult[indexPath.row];
    [self.navigationController pushViewController:playController animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) { [tableView setSeparatorInset:UIEdgeInsetsZero]; }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) { [tableView setLayoutMargins:UIEdgeInsetsZero]; }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { [cell setLayoutMargins:UIEdgeInsetsZero]; }
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
    [Utilities alertMessage:resultMessage withController:self];
}


@end
