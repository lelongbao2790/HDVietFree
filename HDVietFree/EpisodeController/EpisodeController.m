//
//  EpisodeController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/3/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "EpisodeController.h"
#import "EpisodeCell.h"

@interface EpisodeController ()< LoadLinkPlayMovieDelegate, MPMediaPickerControllerDelegate, FixAutolayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate, AllSeasonDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionAllSeason;
@property (strong, nonatomic) NSString *convertResolution;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csLeadingCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionEpisode;
@property (weak, nonatomic) IBOutlet UILabel *lbNameSeason;
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
    
    self.lbNameSeason.text = [NSString stringWithFormat:@"   %@",self.movie.movieName];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Config collection
    [self.collectionAllSeason registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:kDetailMovieCell];
     [self.collectionEpisode registerClass:[EpisodeCell class] forCellWithReuseIdentifier:@"EpisodeCell"];
    self.collectionAllSeason.dataSource = self;
    self.collectionAllSeason.delegate = self;
    self.collectionEpisode.dataSource = self;
    self.collectionEpisode.delegate = self;
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
    
    [self.collectionAllSeason reloadData];
    [self.collectionEpisode reloadData];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Collection View Delegate **

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (collectionView.tag) {
        case kTagCollectionViewEpisode:
            return self.listEpisode.count;
            break;
            
        default:
            return self.listSeason.count;
            break;
    }
}

- (void)setCellSelected:(UICollectionViewCell *)cell {
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithHexString:kColorBgNavigationBar];
    [cell setSelectedBackgroundView:bgColorView];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (collectionView.tag) {
        case kTagCollectionViewEpisode: {
            EpisodeCell *cell = (EpisodeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellEpisodeIdentifier forIndexPath:indexPath];
            NSInteger nameEpisode = indexPath.row + 1;
            [cell loadInformation:[NSString stringWithFormat:@"Tập %d", (int)nameEpisode]];
            [self setCellSelected:cell];
            return cell;
        }
            break;
            
        default: {
            DetailMovieCell *cell = (DetailMovieCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionDetailMovieIdentifier forIndexPath:indexPath];
            cell.movie = self.listSeason[indexPath.row];
            
            [Utilities customLayer:cell.imageMovie];
            [cell loadInformationWithMovie:self.listSeason[indexPath.row]];
            return cell;
        }
            break;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (collectionView.tag) {
        case kTagCollectionViewEpisode: {
            ProgressBarShowLoading(kLoading);
            [[ManageAPI share] loadLinkToPlayMovie:self.movie andEpisode:indexPath.row+1];
            [[AppDelegate share].mainPanel showCenterPanelAnimated:YES];
        }
            break;
            
        default: {
            if (kPlayViewController) {
                kPlayViewController.movie = self.listSeason[indexPath.row];
                [kPlayViewController getInformationMovie];
            }
            
            self.movie = self.listSeason[indexPath.row];
            [self configCollection];
        }
            break;
    }
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
