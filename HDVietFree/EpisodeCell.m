//
//  EpisodeCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/26/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "EpisodeCell.h"

@implementation EpisodeCell

- (void)loadInformation:(NSString *)nameEpisode {
    self.lbEpisode.text = nameEpisode;
}

@end
