//
//  PlayController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/22/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "PlayController.h"

@import MediaPlayer;

@interface PlayController ()<MPMediaPickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, DetailInformationMovieDelegate, LoadLinkPlayMovieDelegate, FixAutolayoutDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagePoster;
@property (weak, nonatomic) IBOutlet UITableView *tbvInforMovie;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayMovie;
@property (strong, nonatomic) NSString *convertResolution;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutTableView;
@end

@implementation PlayController

//*****************************************************************************
#pragma mark -
#pragma mark - ** Life cycle method **
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
     NavigationMovieCustomController *navCustom = (NavigationMovieCustomController *)self.navigationController;
    [navCustom.txtSearch removeFromSuperview];
    
    [self getInformationMovie];
}

- (void)viewWillDisappear:(BOOL)animated {
    NavigationMovieCustomController *navCustom = (NavigationMovieCustomController *)self.navigationController;
    [navCustom initTextField];
    kPlayViewController = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    kPlayViewController = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//*****************************************************************************
#pragma mark -
#pragma mark - ** Media play controller **


//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

- (void)resetView {
    self.movie = nil;
    self.imagePoster.image = nil;
    self.title = kEmptyString;
    [self.tbvInforMovie reloadData];
    [self configView];
}

- (void)configView {
    // Config table view
    self.tbvInforMovie.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvInforMovie.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tbvInforMovie reloadData];
    
    [DataManager shared].detailInfoMovieDelegate = self;
    [DataManager shared].loadLinkPlayMovieDelegate = self;
    [Utilities fixAutolayoutWithDelegate:self];
    [self initEpisodeBarButton];
}

- (void)loadImage {
    
    UIImage *imageFromCache = [[Utilities share]getCachedImageForKey:self.movie.backdrop945530];
    
    if (imageFromCache) {
        [self updateUIImageAvatar:imageFromCache];
    } else {
        if ([Utilities isExistImage:self.movie.backdrop945530]) {
            // Exist image
            [[Utilities share]cacheImage:[Utilities loadImageFromName:self.movie.backdrop945530] forKey:self.movie.backdrop945530];
            [self updateUIImageAvatar:[Utilities loadImageFromName:self.movie.backdrop945530]];
        } else {
            [self downloadImage];
            
        }
    }
}

- (void)downloadImage {
    // Not exist
    __block NSData *data = nil;
    NSString *strImageUrl = self.movie.backdrop945530;
    NSURL *urlImage = [NSURL URLWithString:strImageUrl];
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create(kLoadImageInBackground, 0);
    dispatch_async(backgroundQueue, ^{
        
        // Download
        data = [NSData dataWithContentsOfURL:urlImage];
        UIImage *image = [UIImage imageWithData:data];
        [Utilities saveImage:image withName:self.movie.backdrop945530];
        [[Utilities share]cacheImage:image forKey:self.movie.backdrop945530];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Load image on UI
            [self updateUIImageAvatar:image];
        });
    });
}

// This method will update image avatar
- (void)updateUIImageAvatar:(UIImage*)images {
    self.imagePoster.image = images;
}

- (void)reloadView {
    self.title = [self.movie.movieName uppercaseString];
    [self loadImage];
    [self.tbvInforMovie reloadData];
}

- (void)initEpisodeBarButton {
    if (self.movie.episode > 0) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Episode" style:UIBarButtonItemStylePlain target:self action:@selector(handleEpisode)];
        self.navigationItem.rightBarButtonItem = barButton;
    }
}

- (void)handleEpisode {
    if (self.movie.episode > 0) {
       
        EpisodeController *episodeController = InitStoryBoardWithIdentifier(kEpisodeController);
        episodeController.movie = self.movie;
        [AppDelegate share].mainPanel.rightPanel = episodeController;
        [[AppDelegate share].mainPanel showRightPanelAnimated:YES];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Table view delegate **

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return kNumberOfSectionPlayMovie;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case kSectionInformationMovie:
            return self.movie.movieName;
            break;
            
        case kSectionCategoryFilm:
            return kRelativeMovie;
            break;
        default:
            break;
    }
    
    return kEmptyString;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithHexString:kBackgroundColorOfSection];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    header.textLabel.font = [UIFont systemFontOfSize:16];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case kSectionInformationMovie: {
            PlayMovieCell *cellPlayMovie = (PlayMovieCell *)[tableView dequeueReusableCellWithIdentifier:kPlayMovieCellIdentifier];
            if (!cellPlayMovie) {
                cellPlayMovie = [[PlayMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlayMovieCellIdentifier];
            }
            cellPlayMovie.movie = self.movie;
            [cellPlayMovie setDetailInformation];
            
            cell = cellPlayMovie;

        }
            break;
            
        case kSectionCategoryFilm: {
            MovieCell *cellMovie = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewMoviedentifier];
            if (!cellMovie) {
                cellMovie = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewMoviedentifier];
            }
            
            // Config cell
            NSArray *listRelativeMovieInLocal = [[DataAccess share] getRelativeMovieInDB:self.movie.movieID];
            [cellMovie.collectionViewMovie setCollectionViewDataSourceDelegateWithController:kTagPlayController
                                                                                andListMovie:listRelativeMovieInLocal];
            cell = cellMovie;
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) { [tableView setSeparatorInset:UIEdgeInsetsZero]; }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) { [tableView setLayoutMargins:UIEdgeInsetsZero]; }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { [cell setLayoutMargins:UIEdgeInsetsZero]; }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Handle get information movie **
- (void)getInformationMovie {
    if ([[DataAccess share] getRelativeMovieInDB:self.movie.movieID].count > 0 && self.movie.backdrop945530 != nil) {
        [self reloadView];
    } else {
        ProgressBarShowLoading(kLoading);
        [[ManageAPI share] loadDetailInfoMovieAPI:self.movie];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Detail Information Movie Delegate **
- (void)loadDetailInformationMovieAPISuccess:(NSDictionary *)response {
    ProgressBarDismissLoading(kEmptyString);
    DLOG(@"Load detail information api success");
    if (![response isKindOfClass:[NSNull class]]) {
        [Movie updateInformationMovieFromJSON:response andMovie:self.movie];
    } else {
        [Utilities showiToastMessage:@"Không có thông tin về film này"];
    }
    
    [self reloadView];
}

- (void)loadDetailInformationMovieAPIFail:(NSString *)resultMessage {
    DLOG(@"Load detail information api fail");
    [Utilities loadServerFail:self withResultMessage:resultMessage];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Load Link Movie Delegate **

- (void)loadLinkPlayMovieAPISuccess:(NSDictionary *)response {
    if (![response isKindOfClass:[NSNull class]]) {
        NSString *linkPlay = [response objectForKey:kLinkPlay];
        NSString *linkSub = [[[response objectForKey:kSubtitleExt]
                              objectForKey:kSubtitleVIE]
                             objectForKey:kSubtitleSource];
        
        if (linkSub) {
            self.movie.urlLinkSubtitleMovie = linkSub;
        }
        
        if (![linkPlay isEqualToString:kEmptyString]) {
            if ([linkPlay containsString:kResolution320480]) {
                linkPlay = [linkPlay stringByReplacingOccurrencesOfString:kResolution320480 withString:self.convertResolution];
            } else if ([linkPlay containsString:kResolution3201024]) {
                linkPlay = [linkPlay stringByReplacingOccurrencesOfString:kResolution3201024 withString:self.convertResolution];
            }
            self.movie.urlLinkPlayMovie = linkPlay;
            [Utilities playMediaLink:self.movie.urlLinkPlayMovie andSub:self.movie.urlLinkSubtitleMovie andController:self];
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
#pragma mark - ** IBAction **
- (IBAction)btnPlayMovie:(id)sender {
    ProgressBarShowLoading(kLoading);
    [[ManageAPI share] loadLinkToPlayMovie:self.movie andEpisode:0];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {
    self.convertResolution = kResolution320480;
}

- (void)fixAutolayoutFor40 {
    self.convertResolution = kResolution320568;
}

- (void)fixAutolayoutFor47 {
    self.convertResolution = kResolution7501334;
}

- (void)fixAutolayoutFor55 {
    self.convertResolution = kResolution12422208;
}

-(void)fixAutolayoutForIpad {
    self.convertResolution = kResolution7681024;
    self.topLayoutTableView.constant = kTopConstantTableView;
}
@end
