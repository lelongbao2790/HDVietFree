
//
//  DetailMovieCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "DetailMovieCell.h"

@implementation DetailMovieCell

- (void)awakeFromNib {
    self.lbEpsiode.layer.cornerRadius = self.lbEpsiode.frame.size.width / 2;
    self.lbEpsiode.layer.masksToBounds = YES;
}

- (void)loadInformationWithMovie:(Movie *)movie {
    [self setImagePoster:movie];
    self.lbNameMovie.text = movie.movieName;
    [[Source share] showEpisodeOnDetailCell:self.lbEpsiode withMovie:movie];
    
}

/*
 * Set avatar image
 */
- (void)setImagePoster:(Movie *)movie {
    
    // Request image
    NSURLRequest *requestPoster = [[Source share] requestPosterMovie:movie];
    [self.imageMovie setImageWithURLRequest:requestPoster
                   placeholderImage:[UIImage imageNamed:kNoImage]
                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                self.imageMovie.image = image;
                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                self.imageMovie.image = [UIImage imageNamed:kNoImage];
                            }];
    
    // Check type cell
    if (self.typeCell == kTypeFilm) {
        [Utilities customLayer:self.imageMovie];
    }
}

// This method will update image avatar
- (void)updateUIImageAvatar:(UIImage*)images withMovie:(Movie *)movie {
    self.lbNameMovie.text = movie.movieName;
    if (images) {
        self.imageMovie.image = images;
    } else {
        self.imageMovie.image = [UIImage imageNamed:kNoImage];
    }
}

@end
