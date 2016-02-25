//
//  DetailMovieCell.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageMovie;
@property (weak, nonatomic) IBOutlet UILabel *lbNameMovie;
@property (assign, nonatomic) NSInteger typeCell;
@property (weak, nonatomic) IBOutlet UILabel *lbEpsiode;
@property (strong, nonatomic) Movie *movie;
- (void)loadInformationWithMovie:(Movie *)movie;

@end
