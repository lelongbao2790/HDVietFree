//
//  TopMovieCell.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/28/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopMovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backdropImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoading;

/*
  * Load image on cell
  */
- (void)loadInformationOnTop:(Movie *)aMovie;

@end
