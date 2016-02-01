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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadInformationWithMovie:(Movie *)movie {
    self.lbNameMovie.text = movie.movieName;
    [self setImagePoster:movie];
    self.lbPlot.text = movie.plotVI;
}

/*
 * Set avatar image
 */
- (void)setImagePoster:(Movie *)movie {
    
    if ([Utilities isExistImage:movie.poster]) {
        // Exist image
        [self.activityLoading stopAnimating];
        [self updateUIImageAvatar:[Utilities loadImageFromName:movie.poster] withMovie:movie];
        
    } else {
        self.imgPoster.image = nil;
        [self.activityLoading startAnimating];
        // Not exist
        __block NSData *data = nil;
        NSString *strImageUrl = [Utilities getStringUrlPoster:movie];
        NSURL *urlImage = [NSURL URLWithString:strImageUrl];
        
        dispatch_queue_t backgroundQueue = dispatch_queue_create(kLoadImageInBackground, 0);
        dispatch_async(backgroundQueue, ^{
            
            // Download
            data = [NSData dataWithContentsOfURL:urlImage];
            UIImage *image = [UIImage imageWithData:data];
            [Utilities saveImage:image withName:movie.poster];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Load image on UI
                [self updateUIImageAvatar:image withMovie:movie];
            });
        });
    }
    
}

// This method will update image avatar
- (void)updateUIImageAvatar:(UIImage*)images withMovie:(Movie *)movie {
    [self.activityLoading stopAnimating];
    self.imgPoster.image = images;
    self.lbNameMovie.text = movie.movieName;
    self.lbPlot.text = movie.plotVI;
}

@end
