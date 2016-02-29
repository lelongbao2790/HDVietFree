//
//  MainController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "MainController.h"

@interface MainController ()<UITableViewDataSource, UITableViewDelegate, ListMovieByGenreDelegate, FixAutolayoutDelegate, iCarouselDataSource, iCarouselDelegate>

// Property
@property (weak, nonatomic) IBOutlet iCarousel *bannerView;
@property (strong, nonatomic) NSDictionary *dictMenu;
@property (strong, nonatomic) NSDictionary *dictMovie;
@property (assign, nonatomic) NSInteger lastListMovie;
@property (strong, nonatomic) NSMutableArray *listMovieOnMain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeightBanner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIView *contentViewOfScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeightContentViewScrollView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


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

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    self.bannerView.delegate = nil;
    self.bannerView.dataSource = nil;
    
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

- (void)configView {
    [AppDelegate share].mainController = self;
    self.dictMenu = getDictTitleMenu([MovieSearch share].genreMovie);
    
    [DataManager shared].listMovieDelegate = self;
    self.lastListMovie = 0;
    
    // Config table view
    self.tbvListMovie.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvListMovie.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.tbvListMovie.delegate = self;
    self.tbvListMovie.dataSource = self;
    [self fixedTableViewScrollHeader];
    self.tbvListMovie.scrollEnabled = NO;
    
    // Check list data
    self.listMovieOnMain = [[NSMutableArray alloc] init];
    
    [Utilities fixAutolayoutWithDelegate:self];
    self.bannerView.delegate = self;
    self.bannerView.dataSource = self;
     self.bannerView.type = iCarouselTypeCoverFlow2;
    [self addRefreshController];
    [self checkListMovie];
}

- (void)addRefreshController {
    self.refreshControl = [[UIRefreshControl alloc] init];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Refreshing data..."
                                                                attributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithAttributedString:title];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.refreshControl];
    
    [self.view addSubview:self.scrollView];
}

- (void)fixedTableViewScrollHeader {
    CGFloat dummyViewHeight = 28;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tbvListMovie.bounds.size.width, dummyViewHeight)];
    self.tbvListMovie.tableHeaderView = dummyView;
    self.tbvListMovie.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
}

- (void)initSearchBarButton {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:kSearchIcon] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButton)];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)searchBarButton {
    SearchController *searchController = InitStoryBoardWithIdentifier(kSearchController);
    [self.navigationController pushViewController:searchController animated:YES];
}

- (void)getListMovieShowOnBanner {
    [[DataAccess share] listMovieLocalByTag:kShowMovieTop
                                   andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                    andPage:kPageDefault completionBlock:^(BOOL success, NSMutableArray *array) {
                                        if (success) {
                                            self.listMovieOnMain = [array mutableCopy];
                                            [self.bannerView reloadData];
                                        }
                                    }];
}

- (void)refreshData:(UIRefreshControl *)refreshControl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestRefreshListMovie];
        [NSThread sleepForTimeInterval:3];
    });
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Table view delegate **

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (NSInteger)self.dictMenu.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *arrayKey = [Utilities sortArrayFromDict:self.dictMenu];
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.tag = section;
    headerLabel.userInteractionEnabled = YES;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = [NSString stringWithFormat:@"    %@",[self.dictMenu objectForKey:arrayKey[section]]];
    headerLabel.font = [UIFont boldSystemFontOfSize:kFontSize17];
    [headerLabel setTextColor:[UIColor whiteColor]];
    headerLabel.frame = CGRectMake(0, 0, tableView.tableHeaderView.frame.size.width, tableView.tableHeaderView.frame.size.height);
    headerLabel.textAlignment = NSTextAlignmentLeft;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHeader:)];
    tapGesture.cancelsTouchesInView = NO;
    [headerLabel addGestureRecognizer:tapGesture];
    
    return headerLabel;
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
    
    [Utilities setColorOfSelectCell:cell];
    
    [[DataAccess share] listMovieLocalByTag:[Utilities sortArrayFromDict:self.dictMenu][indexPath.section]
                                   andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                    andPage:kPageDefault completionBlock:^(BOOL success, NSMutableArray *array) {
                                        if (success) {
                                            [cell.collectionViewMovie setListMovieDb:array];
                                        }
                                    }];
    
    return cell;
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Handle list movie **

- (void)requestRefreshListMovie {
    self.lastListMovie = 0;
    DLOG(@"Refresh menu : %d", (int)self.dictMenu.allKeys.count);
    
    for (int i = 0; i < self.dictMenu.allKeys.count; i++) {

        // Not exist - Request server to get list
        [[ManageAPI share] loadListMovieAPI:[MovieSearch share].genreMovie tag:[Utilities sortArrayFromDict:self.dictMenu][i] andPage:kPageDefault];
    }
}

- (void)checkListMovie {
    DLOG(@"Total menu : %d", (int)self.dictMenu.allKeys.count);
    
    for (int i = 0; i < self.dictMenu.allKeys.count; i++) {
        [[DataAccess share] checkExistDataMovieWithGenre:stringFromInteger([MovieSearch share].genreMovie) andTag:[Utilities sortArrayFromDict:self.dictMenu][i] andPage:kPageDefault completionBlock:^(BOOL success, NSMutableArray *array) {
            if (success) {
                self.lastListMovie += 1;
                ProgressBarDismissLoading(kEmptyString);
                [self lastList];
            }
            else {
                ProgressBarShowLoading(kLoading);
                
                // Not exist - Request server to get list
                [[ManageAPI share] loadListMovieAPI:[MovieSearch share].genreMovie tag:[Utilities sortArrayFromDict:self.dictMenu][i] andPage:kPageDefault];
            }
        }];
    }
}

#pragma mark iCarousel methods

- (void)requestBannerImage:(Movie *)movie andImage:(UIImageView *)imageView {
    __weak UIImageView  *newImageView =imageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kUrlImageBannerHdViet,movie.backdrop]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    
    [newImageView setImageWithURLRequest:imageRequest
                           placeholderImage:[UIImage imageNamed:kNoBannerImage]
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        newImageView.image = image;
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        newImageView.image = [UIImage imageNamed:kNoBannerImage];
                                    }];
    
    imageView.image = newImageView.image;
}

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return [self.listMovieOnMain count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bannerView.frame.size.width, self.bannerView.frame.size.height)];
    ((UIImageView *)view).contentMode = UIViewContentModeScaleAspectFill;
    ((UIImageView *)view).clipsToBounds = YES;
    [self requestBannerImage:self.listMovieOnMain[index] andImage:((UIImageView *)view)];
    [Utilities customLayer:view];
    
    return view;
    
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bannerView.frame.size.width - 10, self.bannerView.frame.size.height - 10)];
    ((UIImageView *)view).image = [UIImage imageNamed:kNoBannerImage];
    ((UIImageView *)view).contentMode = UIViewContentModeScaleAspectFill;
    ((UIImageView *)view).clipsToBounds = YES;
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.bannerView.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return 0;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.bannerView.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    PlayController *playController = nil;
    if (kPlayViewController) {
        playController = kPlayViewController;
        playController.movie = self.listMovieOnMain[index];
        [playController getInformationMovie];
    } else {
        playController = InitStoryBoardWithIdentifier(kPlayController);
        playController.movie = self.listMovieOnMain[index];
        [[AppDelegate share].mainController.navigationController pushViewController:playController animated:YES];
    }
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{

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
        self.lastListMovie = 0;
        [self lastList];
        [self endRefreshList];
    } else {
        self.lastListMovie += 1;
    }
    
    [self lastList];
}

- (void)endRefreshList {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshControl) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:lastUpdate
                                                                        attributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithAttributedString:title];
            [self.refreshControl endRefreshing];
            
            NSLog(@"refresh end");

        }
    });

}

- (void)lastList {
    // Check last list category
    if ([Utilities isLastListCategory:self.dictMenu andCurrentIndex:self.lastListMovie andLoop:NO]) {
        
        [self.tbvListMovie reloadData];
        [self getListMovieShowOnBanner];
    }
}

- (void)loadListMovieAPIFail:(NSString *)resultMessage {
    [Utilities loadServerFail:self withResultMessage:resultMessage];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {
    self.csHeightContentViewScrollView.constant = kHeightContentViewScrollViewIp4;
}

- (void)fixAutolayoutFor40 {
    self.csHeightContentViewScrollView.constant = kHeightContentViewScrollViewIp5;
}

- (void)fixAutolayoutFor47 {
    self.csHeightContentViewScrollView.constant = kHeightContentViewScrollViewIp6;
}

- (void)fixAutolayoutFor55 {
    self.csHeightContentViewScrollView.constant = kHeightContentViewScrollViewIp6Plus;
}

-(void)fixAutolayoutForIpad {
    self.csHeightBanner.constant += kTopConstantIpad;
    self.csHeightContentViewScrollView.constant = kHeightContentViewScrollViewIpad;
}


@end
