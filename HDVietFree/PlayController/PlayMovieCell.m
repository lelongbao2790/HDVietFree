//
//  PlayMovieCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/27/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "PlayMovieCell.h"

@implementation PlayMovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailInformation:(Movie *)movie {
    
    self.lbCast.text = movie.cast;
    self.lbCountry.text = movie.country;
    self.lbPlot.text = movie.plotVI;
    self.lbReleaseDate.text = [Utilities getYearOfDateFromString:movie.releaseDate];
    self.lbTagMovie.text = [kDicMainMenu objectForKey:movie.tagMovie];

}

@end
