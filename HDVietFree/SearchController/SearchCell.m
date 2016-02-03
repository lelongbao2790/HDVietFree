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
    
    UIImage *imageFromCache = [[Utilities share]getCachedImageForKey:movie.poster];
    
    if (imageFromCache) {
        [self updateUIImageAvatar:imageFromCache withMovie:movie];
    } else {
        if ([Utilities isExistImage:movie.poster]) {
            // Exist image
            [self updateUIImageAvatar:[Utilities loadImageFromName:movie.poster] withMovie:movie];
        } else {
            [self downloadImage:movie];
            
        }
    }
}

- (void)downloadImage:(Movie *)movie {
    // Not exist
    self.imgPoster.image = nil;
    [self.activityLoading startAnimating];
    NSString *strImageUrl = [Utilities getStringUrlPoster:movie];
    NSURL *urlImage = [NSURL URLWithString:strImageUrl];
    
    // Using GCD to download image
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // Download
        NSData *data = [NSData dataWithContentsOfURL:urlImage];
        UIImage *image = [UIImage imageWithData:data];
        [Utilities saveImage:image withName:movie.poster];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // Load image on UI main thread
            UIImage *cacheImage = [Utilities loadImageFromName:movie.poster];
            [self updateUIImageAvatar:cacheImage withMovie:movie];
        });
    });
}

// This method will update image avatar
- (void)updateUIImageAvatar:(UIImage*)images withMovie:(Movie *)movie {
    [self.activityLoading stopAnimating];
    self.imgPoster.image = images;
    self.lbNameMovie.text = movie.movieName;
    self.lbPlot.text = movie.plotVI;
    [[Utilities share]cacheImage:images forKey:movie.poster];
}

@end
