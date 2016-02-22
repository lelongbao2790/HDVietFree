//
//  MovieCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/26/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionViewMovie.frame = self.contentView.bounds;
    [Utilities fixAutolayoutWithDelegate:self];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {
    self.csTrailing.constant = -8;
}

- (void)fixAutolayoutFor40 {
    self.csTrailing.constant = -8;
}

- (void)fixAutolayoutFor47 {
   self.csTrailing.constant = -8;
}

- (void)fixAutolayoutFor55 {
    self.csTrailing.constant = -8;
}

-(void)fixAutolayoutForIpad {
    self.csTrailing.constant = -8;
}

@end
