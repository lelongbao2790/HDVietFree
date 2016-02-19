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
    
    // Using GCD to download image
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // Download
        UIImage *imageFromCache = [[Utilities share]getCachedImageForKey:movie.poster];
        if (imageFromCache) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self updateUIImageAvatar:imageFromCache withMovie:movie];
            });
            
        } else {
            
            if ([Utilities isExistImage:movie.poster]) {
                [[Utilities share] cacheImage:[Utilities loadImageFromName:movie.poster] forKey:movie.backdrop945530];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // Exist image
                    [self updateUIImageAvatar:[Utilities loadImageFromName:movie.poster] withMovie:movie];
                });
                
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // Exist image
                    [self downloadImage:movie];
                }); 
            }
        }
        
    });
}

- (void)downloadImage:(Movie *)movie {
    if (movie.poster) {
        NSString *strImageUrl = [Utilities getStringUrlPoster:movie];
        [[DataManager shared] downloadImageWithUrl:strImageUrl completionBlock:^(BOOL success, UIImageLoaderImage *image) {
            if (success) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    // Download
                    [Utilities saveImage:image withName:movie.backdrop945530];
                    [[Utilities share] cacheImage:image forKey:movie.backdrop945530];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                         [self updateUIImageAvatar:image withMovie:movie];
                    });
                });
               
            } else {
                self.imgPoster.image = nil;
                [self.activityLoading startAnimating];
            }
        }];
    } else {
        [self updateUIImageAvatar:nil withMovie:movie];
    }
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
    [[Utilities share]cacheImage:images forKey:movie.poster];
}

@end
