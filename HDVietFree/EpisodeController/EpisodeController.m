//
//  EpisodeController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/3/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "EpisodeController.h"

@interface EpisodeController ()<UITableViewDataSource, UITableViewDelegate, LoadLinkPlayMovieDelegate, MPMediaPickerControllerDelegate, FixAutolayoutDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbvEpisode;
@property (strong, nonatomic) NSString *convertResolution;
@end

@implementation EpisodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [DataManager shared].loadLinkPlayMovieDelegate = self;
    [Utilities fixAutolayoutWithDelegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self config];
    [self.tbvEpisode reloadData];
}

- (void)config {
    if (self.movie.episode > 0) {
        NSMutableArray *listEpisode = [[NSMutableArray alloc] init];
        for (int i= 0; i< self.movie.episode; i++) {
            [listEpisode addObject:[NSNumber numberWithInteger:i]];
        }
        self.listEpisode = [listEpisode mutableCopy];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Table view delegate **

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgressBarShowLoading(kLoading);
    [[ManageAPI share] loadLinkToPlayMovie:self.movie andEpisode:indexPath.row+1];
    [[AppDelegate share].mainPanel showCenterPanelAnimated:YES];
}

#pragma mark - ** Load Link Movie Delegate **

- (void)loadLinkPlayMovieAPISuccess:(NSDictionary *)response {
    
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
        [self playMediaControllerWithUrl:linkPlay andSub:linkSub];
    }
    
    ProgressBarDismissLoading(kEmptyString);
}

- (void)loadLinkPlayMovieAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmptyString);
    [Utilities showiToastMessage:resultMessage];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Media play controller **

- (void)playMediaControllerWithUrl:(NSString *)urlLinkPlay andSub:(NSString *)urlLinkSub {
    NSURL *url = [[NSURL alloc] initWithString:urlLinkPlay];
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    player.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    NSString *subString = [Utilities getDataSubFromUrl:urlLinkSub];
    [player.moviePlayer openWithSRTString:subString completion:^(BOOL finished) {
        // Activate subtitles
        [player.moviePlayer showSubtitles];
        
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error.description);
        
        [Utilities showiToastMessage:@"Phim này hiện chưa có sub việt"];
    }];
    
    // Show video
    // Force landscape show video
    CGAffineTransform landscapeTransform;
    landscapeTransform = CGAffineTransformMakeRotation(90*M_PI/180.0f);
    landscapeTransform = CGAffineTransformTranslate(landscapeTransform, 80, 80);
    [player.moviePlayer.view setTransform: landscapeTransform];
    
    // Present video
    [self presentMoviePlayerViewControllerAnimated:player];
    [player.moviePlayer setFullscreen:YES animated:YES];
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
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {
    self.convertResolution = kResolution320480;
}

- (void)fixAutolayoutFor40 {
    self.convertResolution = kResolution320568;
}

- (void)fixAutolayoutFor47 {
    self.convertResolution = kResolution375667;
}

- (void)fixAutolayoutFor55 {
    self.convertResolution = kResolution12422208;
}

-(void)fixAutolayoutForIpad {
    self.convertResolution = kResolution15362048;
}

@end
