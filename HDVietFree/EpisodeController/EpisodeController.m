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
    // Config table
    self.tbvEpisode.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvEpisode.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    // Check episode
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
#pragma mark - ** Media play controller **

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
