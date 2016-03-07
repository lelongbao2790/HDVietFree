//
//  TVChannelController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/7/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "TVChannelController.h"

@interface TVChannelController ()<TVChannelDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionChannel;
@property (strong, nonatomic) NSArray *listChannel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TVChannelController
//*****************************************************************************
#pragma mark -
#pragma mark - ** Life Cycle **
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
}

- (void)viewWillAppear:(BOOL)animated {
    [DataManager shared].tvChannelDelegate = self;
    
    [self requestListChannelFromLocal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **
- (void)config {
    self.title = @"KÊNH TIVI";
     [self.collectionChannel registerClass:[TVChannelCell class] forCellWithReuseIdentifier:kTVChannelCell];
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self addRefreshController];
}

- (void)requestListChannelFromLocal {
    if ([[DataAccess share] getListChannelLocal].count > 0) {
        
        [self reloadList];
    } else {
        // Load first page
        ProgressBarShowLoading(kLoading);
        [[DataManager shared] getALlTVChannel:kRequestChannelHtvOnline];
    }
}

- (void)reloadList {
    self.listChannel = [[[DataAccess share] getListChannelLocal] mutableCopy];
    [self.collectionChannel reloadData];
}

- (void)addRefreshController {
    self.refreshControl = [[UIRefreshControl alloc] init];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Refreshing data..."
                                                                attributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithAttributedString:title];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.collectionChannel addSubview:self.refreshControl];
}

- (void)refreshData:(UIRefreshControl *)refreshControl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[TVChannel query] fetch] removeAll];
        [[DataManager shared] getALlTVChannel:kRequestChannelHtvOnline];
        [NSThread sleepForTimeInterval:3];
    });
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listChannel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    TVChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TVChannelCellIdentifier" forIndexPath:indexPath];
    cell.tvChannel = self.listChannel[indexPath.row];
    [cell loadInformation];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeZero;
    
    if (kDeviceIsPhoneSmallerOrEqual35) {
        returnSize = sizeCellChannelIp5;
    } else if (kDeviceIsPhoneSmallerOrEqual40) {
        returnSize = sizeCellChannelIp5;
    } else if (kDeviceIsPhoneSmallerOrEqual47) {
        returnSize = sizeCellChannelIp6;
    } else if (kDeviceIsPhoneSmallerOrEqual55) {
        returnSize = sizeCellChannelIp6Plus;
    } else if (kDeviceIpad) {
        returnSize = sizeCellChannelIp6;
    }
    return returnSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [PlayMovieController share].channelTv = self.listChannel[indexPath.row];
    [PlayMovieController share].timePlayMovie = 0;
    [[PlayMovieController share] playMovieWithController:self];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** TV Channel Delegate **

- (void)getAllTVChannelAPISuccess:(NSDictionary *)response {
    ProgressBarDismissLoading(kEmptyString);
    if (response.count > 0) {
        NSArray *listChannelResponse = [response objectForKey:kData];
        for (NSDictionary *dictChannel in listChannelResponse) {
            [TVChannel initChannelFromJSON:dictChannel];
        }
        [self endRefreshList];
        [self reloadList];
    }
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
            [self.collectionChannel reloadData];
            NSLog(@"refresh end");
            
        }
    });
}

- (void)getAllTVChannelAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmptyString);
    [Utilities showiToastMessage:resultMessage];
}

@end
