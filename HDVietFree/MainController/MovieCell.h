//
//  MovieCell.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/26/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionMovie;

@interface MovieCell : UITableViewCell<FixAutolayoutDelegate>
@property (strong, nonatomic) IBOutlet CollectionMovie *collectionViewMovie;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csTrailing;

@end
