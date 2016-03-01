//
//  EpisodeController.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/3/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeController : UIViewController

@property (strong, nonatomic) NSArray *listEpisode;
@property (strong, nonatomic) NSArray *listSeason;
@property (strong, nonatomic) Movie *movie;
@property (assign, nonatomic) NSInteger epiNumber;
- (void)configCollection;
@end
