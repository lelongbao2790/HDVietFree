//
//  PlayController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/22/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "PlayController.h"
#define kResolution320480 @"320_480"
#define kResolution3201024 @"320_1024"
#define kResolution320568 @"320_568"
#define kResolution6401136 @"640_1136"

@import MediaPlayer;

@interface PlayController ()<MPMediaPickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, DetailInformationMovieDelegate, LoadLinkPlayMovieDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagePoster;
@property (weak, nonatomic) IBOutlet UITableView *tbvInforMovie;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayMovie;

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
}

- (void)viewDidAppear:(BOOL)animated {
    
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

- (void)playMediaControllerWithUrl {
    NSURL *url = [[NSURL alloc] initWithString:self.movie.urlLinkPlayMovie];
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    player.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    NSString *subString = [Utilities getDataSubFromUrl:self.movie.urlLinkSubtitleMovie];
    [player.moviePlayer openWithSRTString:subString completion:^(BOOL finished) {
        // Activate subtitles
        [player.moviePlayer showSubtitles];

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error.description);
        
        [Utilities showiToastMessage:@"Phim này hiện chưa có sub việt"];
    }];
    
    // Show video
    [self.navigationController presentMoviePlayerViewControllerAnimated:player];
    [player.moviePlayer play];
}

-(void)moviePlaybackDidFinish:(NSNotification*)aNotification{
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonUserExited) {
        [self dismissMoviePlayerViewControllerAnimated];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

- (void)configView {
    // Config table view
    self.tbvInforMovie.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvInforMovie.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tbvInforMovie reloadData];
    
    [DataManager shared].detailInfoMovieDelegate = self;
    [DataManager shared].loadLinkPlayMovieDelegate = self;
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
    [self loadImage];
    [self.tbvInforMovie reloadData];
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
    [Utilities showiToastMessage:resultMessage];
    ProgressBarDismissLoading(kEmptyString);
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Load Link Movie Delegate **

- (void)loadLinkPlayMovieAPISuccess:(NSDictionary *)response {
    
    NSString *linkPlay = [response objectForKey:kLinkPlay];
    NSString *linkSub = [[[response objectForKey:kSubtitleExt]
                                    objectForKey:kSubtitleVIE]
                                    objectForKey:kSubtitleSource];
    
    NSString *convertResolution = [NSString stringWithFormat:@"%d_%d",(int)[Utilities widthOfScreen],(int)[Utilities heightOfScreen]];
    
    if (linkSub) {
        self.movie.urlLinkSubtitleMovie = linkSub;
    }
    
    if (![linkPlay isEqualToString:kEmptyString]) {
        if ([linkPlay containsString:kResolution320480]) {
            linkPlay = [linkPlay stringByReplacingOccurrencesOfString:kResolution320480 withString:convertResolution];
        } else if ([linkPlay containsString:kResolution3201024]) {
            linkPlay = [linkPlay stringByReplacingOccurrencesOfString:kResolution3201024 withString:convertResolution];
        }
        self.movie.urlLinkPlayMovie = linkPlay;
        [self playMediaControllerWithUrl];
    }
    
    ProgressBarDismissLoading(kEmptyString);
}

- (void)loadLinkPlayMovieAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmptyString);
    [Utilities showiToastMessage:resultMessage];
    // Remove access token save
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** IBAction **
- (IBAction)btnPlayMovie:(id)sender {
    ProgressBarShowLoading(kLoading);
    [[ManageAPI share] loadLinkToPlayMovie:self.movie];
}

@end
