
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
}

- (void)loadInformationWithMovie:(Movie *)movie {
    [self setImagePoster:movie];
}

/*
 * Set avatar image
 */
- (void)setImagePoster:(Movie *)movie {
    self.lbNameMovie.text = movie.movieName;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[Utilities getStringUrlPoster:movie]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];

    
    [self.imageMovie setImageWithURLRequest:imageRequest
                     placeholderImage:[UIImage imageNamed:kNoImage]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  self.imageMovie.image = image;
                              } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                  self.imageMovie.image = [UIImage imageNamed:kNoImage];
                              }];
    if (self.typeCell == kTypeFilm) {
        [Utilities customLayer:self.imageMovie];
    }
    
}

// This method will update image avatar
- (void)updateUIImageAvatar:(UIImage*)images withMovie:(Movie *)movie {
    [self.activityLoading stopAnimating];
    self.lbNameMovie.text = movie.movieName;
    if (images) {
        self.imageMovie.image = images;
    } else {
        self.imageMovie.image = [UIImage imageNamed:kNoImage];
    }
}

@end
