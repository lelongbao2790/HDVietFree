//
//  Source.h
//  HomeMovie
//
//  Created by Bao (Brian) L. LE on 3/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
//*****************************************************************************
#pragma mark -
#pragma mark - ** Source **

@interface Source : NSObject

// Property
@property (strong, nonatomic) NSDictionary *dictMainMenu;
@property (strong, nonatomic) NSDictionary *dictLeftMenu;

+ (Source *)share;

- (void)initSource:(NSInteger)lastListMovie andTable:(UITableView *)tbvListMovie andCompletion:(completionDataBlock)completion;

- (void)checkSourceMovie:(NSInteger)lastListMovie andTableView:(UITableView *)tbvListMovie;

- (void)requestRefreshListMovie;

- (void)loadListMovieLocal:(NSInteger)section andCompletion:(completionDataBlock)completion;

- (void)loadListAPISuccess:(NSDictionary *)response andLast:(NSInteger)lastListMovie andRefresh:(UIRefreshControl *)refreshController andKey:(NSString *)key;

- (void)showEpisodeOnDetailCell:(UILabel *)lbEpisode withMovie:(Movie *)movie;

- (NSURLRequest *)requestPosterMovie:(Movie *)movie;

/*
 * Show detail information on play controller
 */
- (void)showDetailInforOnPlayController:(UILabel *)lbCast
                                country:(UILabel *)lbCountry
                                   plot:(UITextView *)lbPlot
                               tagMovie:(UILabel *)lbTagMovie
                            releaseDate:(UILabel *)lbReleaseDate
                               andMovie:(Movie *)movie;

@end

//*****************************************************************************
#pragma mark -
#pragma mark - ** Source HDO **
@interface SourceHDO : Source

+ (SourceHDO *)initSourceHDO;

@end

//*****************************************************************************
#pragma mark -
#pragma mark - ** Source HDV **
@interface SourceHDV : Source

// Property
@property (strong, nonatomic) NSString *tagMovie;
@property (assign, nonatomic) NSInteger page;

+ (SourceHDV *)initSourceHDV;

@end