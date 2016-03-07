//
//  TVChannelCell.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/7/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TVChannel;
@interface TVChannelCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *subviewCell;
@property (weak, nonatomic) IBOutlet UIImageView *imageChannel;
@property (strong, nonatomic) TVChannel *tvChannel;

- (void)loadInformation;

@end
