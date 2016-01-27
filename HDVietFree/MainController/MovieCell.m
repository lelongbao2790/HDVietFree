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
}

@end
