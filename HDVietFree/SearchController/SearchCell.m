//
//  SearchCell.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/1/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    // Initialization code
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.imgPoster.layer.cornerRadius = 5.0;
    self.imgPoster.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadInformationWithMovie:(Movie *)movie {
    self.lbNameMovie.text = movie.movieName;
    self.lbPlot.text = movie.plotVI;
    [self setImagePoster:movie];
}

/*
 * Set avatar image
 */
- (void)setImagePoster:(Movie *)movie {
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[Utilities getStringUrlPoster:movie]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [self.imgPoster setImageWithURLRequest:imageRequest
                            placeholderImage:[UIImage imageNamed:kNoImage]
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         self.imgPoster.image = image;
                                     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                         self.imgPoster.image = [UIImage imageNamed:kNoImage];
                                     }];
}

// This method will update image avatar
- (void)updateUIImageAvatar:(UIImage*)images withMovie:(Movie *)movie {
    [self.activityLoading stopAnimating];
    self.lbNameMovie.text = movie.movieName;
    self.lbPlot.text = movie.plotVI;
    if (images) {
        self.imgPoster.image = images;
        
    } else {
        self.imgPoster.image = [UIImage imageNamed:kNoImage];
    }
    MovieHDV *movieHdv = (MovieHDV *)movie;
    [[Utilities share]cacheImage:images forKey:movieHdv.poster];
}

@end
