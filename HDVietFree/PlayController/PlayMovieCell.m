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

- (void)setDetailInformation {
    
    [[Source share] showDetailInforOnPlayController:self.lbCast country:self.lbCountry
                                               plot:self.lbPlot tagMovie:self.lbTagMovie releaseDate:self.lbReleaseDate andMovie:self.movie];
}
- (IBAction)btnTrailer:(id)sender {
    if (![self.movie.trailer isEqualToString:kEmptyString]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.movie.trailer]];
    }
}

@end
