//
//  EpisodeController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/3/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "EpisodeController.h"

@interface EpisodeController ()<UITableViewDataSource, UITableViewDelegate, LoadLinkPlayMovieDelegate, MPMediaPickerControllerDelegate, FixAutolayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate, AllSeasonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbvEpisode;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionAllSeason;
@property (strong, nonatomic) NSString *convertResolution;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csLeadingCollectionView;
@end

@implementation EpisodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [DataManager shared].loadLinkPlayMovieDelegate = self;
    [Utilities fixAutolayoutWithDelegate:self];
    [self config];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)config {
    // Config table
    self.tbvEpisode.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvEpisode.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.tbvEpisode reloadData];
    
    // Config collection
    [self.collectionAllSeason registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:kDetailMovieCell];
    self.collectionAllSeason.dataSource = self;
    self.collectionAllSeason.delegate = self;
    [DataManager shared].allSeasonDelegate = self;
    
    [self configCollection];
}

- (void)configCollection {
    
    // Check episode
    if (self.movie.episode > 0) {
        NSMutableArray *listEpisode = [[NSMutableArray alloc] init];
        for (int i= 0; i< self.movie.episode; i++) {
            [listEpisode addObject:[NSNumber numberWithInteger:i]];
        }
        self.listEpisode = [listEpisode mutableCopy];
    }
    
    self.listSeason = [[[DataAccess share] getAllSeasonMovieInDB:self.movie.movieID] mutableCopy];
    if (!self.listSeason) {
        ProgressBarShowLoading(kLoading);
        [[ManageAPI share] loadAllSeasonMovieAPI:self.movie];
    } else {
        [self.collectionAllSeason reloadData];
    }
    
    int currentItem = 0;
    for (int i=0; i< self.listSeason.count; i++) {
        Movie *movie = self.listSeason[i];
        if ([movie.movieID isEqualToString:self.movie.movieID]) {
            currentItem = i;
            break;
        }
    }
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentItem inSection:0];
//    [self.collectionAllSeason scrollToItemAtIndexPath:indexPath
//                               atScrollPosition:UICollectionViewScrollPositionNone
//                                       animated:NO];
    
    [self.collectionAllSeason reloadData];
    [self.tbvEpisode reloadData];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Table view delegate **

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.tag = section;
    headerLabel.userInteractionEnabled = YES;
    headerLabel.backgroundColor = [UIColor colorWithHexString:kBgColorOfHeader];
    headerLabel.text = [NSString stringWithFormat:@"   %@",self.movie.movieName];
    headerLabel.font = [UIFont boldSystemFontOfSize:kFontSize15];
    [headerLabel setTextColor:[UIColor colorWithHexString:kTextColorOfHeader]];
    headerLabel.frame = CGRectMake(0, 0, tableView.tableHeaderView.frame.size.width, tableView.tableHeaderView.frame.size.height);
    headerLabel.textAlignment = NSTextAlignmentLeft;

    return headerLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listEpisode.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Init cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListEpisodeTableViewIdentifier"];
    if(!cell) { cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListEpisodeTableViewIdentifier"]; }
    
    NSInteger nameEpisode = indexPath.row + 1;
    cell.textLabel.text = [NSString stringWithFormat:@"Tập %d", (int)nameEpisode];
    cell.textLabel.textColor = [ UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) { [tableView setSeparatorInset:UIEdgeInsetsZero]; }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) { [tableView setLayoutMargins:UIEdgeInsetsZero]; }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { [cell setLayoutMargins:UIEdgeInsetsZero]; }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgressBarShowLoading(kLoading);
    [[ManageAPI share] loadLinkToPlayMovie:self.movie andEpisode:indexPath.row+1];
    [[AppDelegate share].mainPanel showCenterPanelAnimated:YES];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Collection View Delegate **

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listSeason.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailMovieCell *cell = (DetailMovieCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionDetailMovieIdentifier forIndexPath:indexPath];
    cell.movie = self.listSeason[indexPath.row];
    
    [Utilities customLayer:cell.imageMovie];
    
//    if (cell.selected) {
//        cell.backgroundColor = [UIColor colorWithHexString:kColorBgNavigationBar]; // highlight selection
//    }
//    else
//    {
//        cell.backgroundColor = [UIColor clearColor]; // Default color
//    }
    
    [cell loadInformationWithMovie:self.listSeason[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (kPlayViewController) {
        kPlayViewController.movie = self.listSeason[indexPath.row];
        [kPlayViewController getInformationMovie];
    }
    
    self.movie = self.listSeason[indexPath.row];
    [self configCollection];
}


#pragma mark - ** Load Link Movie Delegate **

- (void)loadLinkPlayMovieAPISuccess:(NSDictionary *)response {
    if (![response isKindOfClass:[NSNull class]]) {
        NSString *linkPlay = [response objectForKey:kLinkPlay];
        NSString *linkSub = [[[response objectForKey:kSubtitleExt]
                              objectForKey:kSubtitleVIE]
                             objectForKey:kSubtitleSource];
        
        if (![linkPlay isEqualToString:kEmptyString]) {
            if ([linkPlay containsString:kResolution320480]) {
                linkPlay = [linkPlay stringByReplacingOccurrencesOfString:kResolution320480 withString:self.convertResolution];
            } else if ([linkPlay containsString:kResolution3201024]) {
                linkPlay = [linkPlay stringByReplacingOccurrencesOfString:kResolution3201024 withString:self.convertResolution];
            }
             [Utilities playMediaLink:linkPlay andSub:linkSub andController:self];
        }

    }
    else {
        [Utilities showiToastMessage:kMessageErrorAboutMovie];
    }
    
    ProgressBarDismissLoading(kEmptyString);
}

- (void)loadLinkPlayMovieAPIFail:(NSString *)resultMessage {
    [Utilities loadServerFail:self withResultMessage:resultMessage];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Load All Season Delegate **
- (void)getAllSeasonAPISuccess:(NSDictionary *)response {
    ProgressBarDismissLoading(kEmptyString);
    NSArray *allValue = response.allValues;
    for (NSDictionary *jsonMovie in allValue) {
        [Movie initSeasonMovieFromJSONSearch:jsonMovie andMovie:self.movie];
    }
    
    self.listSeason = [[[DataAccess share] getAllSeasonMovieInDB:self.movie.movieID] mutableCopy];
    [self.collectionAllSeason reloadData];
}

- (void)getAllSeasonAPIFail:(NSString *)resultMessage {
    [Utilities loadServerFail:self withResultMessage:resultMessage];
}


//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {
    self.convertResolution = kResolution320480;
    self.csLeadingCollectionView.constant = kLeadingEpisodeIp5;
}

- (void)fixAutolayoutFor40 {
    self.convertResolution = kResolution320568;
    self.csLeadingCollectionView.constant = kLeadingEpisodeIp5;
}

- (void)fixAutolayoutFor47 {
    self.convertResolution = kResolution375667;
    self.csLeadingCollectionView.constant = kLeadingEpisodeIp6;
}

- (void)fixAutolayoutFor55 {
    self.convertResolution = kResolution12422208;
    self.csLeadingCollectionView.constant = kLeadingEpisodeIp6Plus;
}

-(void)fixAutolayoutForIpad {
    self.convertResolution = kResolution15362048;
}

@end
