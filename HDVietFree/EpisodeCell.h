//
//  EpisodeCell.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/26/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbEpisode;

- (void)loadInformation:(NSString *)nameEpisode;

@end
