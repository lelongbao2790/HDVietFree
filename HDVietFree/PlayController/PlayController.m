//
//  PlayController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/22/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "PlayController.h"

@import MediaPlayer;

@interface PlayController ()<MPMediaPickerControllerDelegate, DetailInformationMovieDelegate, LoadLinkPlayMovieDelegate, FixAutolayoutDelegate, AllSeasonDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagePoster;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayMovie;
@property (strong, nonatomic) NSString *convertResolution;
@property (weak, nonatomic) IBOutlet UIView *informationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (strong, nonatomic) InformationController *infor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csBottomButtonPlay;
@property (strong, nonatomic) EpisodeController *episodeController;

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
    
    [AppDelegate share].mainPanel.rightPanel = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    kPlayViewController = self;
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** IBAction **



//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

- (void)addViewInformation {
    if (!self.infor) {
        self.infor = InitStoryBoardWithIdentifier(kInformationController);
        CGRect frameInfor = CGRectMake(0, 0, self.informationView.frame.size.width , self.informationView.frame.size.height);
        self.infor.view.frame = frameInfor;
        [self.informationView addSubview:self.infor.view];
    }
    
    self.infor.movie = self.movie;
    [self.infor setInformationMovie];
    
}

- (void)configView {
    
    [Utilities fixAutolayoutWithDelegate:self];
    [DataManager shared].detailInfoMovieDelegate = self;
    [DataManager shared].loadLinkPlayMovieDelegate = self;
    [DataManager shared].allSeasonDelegate = self;
    
    // Config table view
    self.imagePoster.layer.borderColor = [UIColor blackColor].CGColor;
    self.imagePoster.layer.borderWidth = 1.0;
    
    [super awakeFromNib];
}

- (void)loadImage {
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.movie.backdrop945530]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [self.imagePoster setImageWithURLRequest:imageRequest
                           placeholderImage:[UIImage imageNamed:kNoBannerImage]
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        self.imagePoster.image = image;
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        self.imagePoster.image = [UIImage imageNamed:kNoBannerImage];
                                    }];
    
}

// This method will update image avatar
- (void)updateUIImageAvatar:(UIImage*)images {
    self.imagePoster.image = images;
}

- (void)reloadView {
    self.title = kEmptyString;
    self.title = self.movie.movieName;
    [self loadImage];
    [self addViewInformation];
}

- (void)initEpisodeBarButton {
    if (self.movie.episode > 0) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"TẬP" style:UIBarButtonItemStylePlain target:self action:@selector(handleEpisode)];
        self.navigationItem.rightBarButtonItem = barButton;
    }
}

- (void)handleEpisode {
    if (self.movie.episode > 0) {
       
        if (self.episodeController == nil) {
            self.episodeController = InitStoryBoardWithIdentifier(kEpisodeController);
        }
        self.episodeController.movie = self.movie;
        [self.episodeController configCollection];
        [AppDelegate share].mainPanel.rightPanel = self.episodeController;
        [[AppDelegate share].mainPanel showRightPanelAnimated:YES];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Handle get information movie **
- (void)getInformationMovie {
    if ([[DataAccess share] getRelativeMovieInDB:self.movie.movieID].count > 0 && self.movie.backdrop945530 != nil) {
        
        if ([[DataAccess share] getAllSeasonMovieInDB:self.movie.movieID].count == 0) {
            // Check all season movie
            ProgressBarShowLoading(kLoading);
            [[ManageAPI share] loadAllSeasonMovieAPI:self.movie];
        }
        
        
        // Exist relative movie
        [self reloadView];
        
    } else {
        ProgressBarShowLoading(kLoading);
        [self updateUIImageAvatar:[UIImage imageNamed:kNoBannerImage]];
        [[ManageAPI share] loadDetailInfoMovieAPI:self.movie];
        [[ManageAPI share] loadAllSeasonMovieAPI:self.movie];
    }
    
    [self initEpisodeBarButton];
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
#pragma mark - ** Load All Season Delegate **
- (void)getAllSeasonAPISuccess:(NSDictionary *)response {
    ProgressBarDismissLoading(kEmptyString);
    NSArray *allValue = response.allValues;
    for (NSDictionary *jsonMovie in allValue) {
        [Movie initSeasonMovieFromJSONSearch:jsonMovie andMovie:self.movie];
    }
}

- (void)getAllSeasonAPIFail:(NSString *)resultMessage {
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
    self.heightConstant.constant = kConstantInformationViewIp4;
}

- (void)fixAutolayoutFor40 {
    self.convertResolution = kResolution320568;
    self.heightConstant.constant = kConstantInformationViewIp5;
}

- (void)fixAutolayoutFor47 {
    self.convertResolution = kResolution7501334;
    self.heightConstant.constant = kConstantInformationViewIp6;
    self.topLayoutTableView.constant = kTopConstantTableViewIp6;
}

- (void)fixAutolayoutFor55 {
    self.convertResolution = kResolution12422208;
    self.topLayoutTableView.constant = kTopConstantTableViewIp6Plus;
    self.heightConstant.constant = kConstantInformationViewIp6Plus;
}

-(void)fixAutolayoutForIpad {
    self.convertResolution = kResolution7681024;
    self.topLayoutTableView.constant = kTopConstantTableView;
    self.heightConstant.constant = kConstantInformationViewIpad;
    self.csBottomButtonPlay.constant -= kBottomConstantIpad;
}
@end
