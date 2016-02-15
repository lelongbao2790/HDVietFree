//
//  FilmController.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/1/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilmController : UICollectionViewController

//*****************************************************************************
#pragma mark -
#pragma mark - ** Property **
@property (strong, nonatomic) NSMutableArray *listMovie;
@property (assign, nonatomic) NSInteger totalItemOnOnePage;
@end
