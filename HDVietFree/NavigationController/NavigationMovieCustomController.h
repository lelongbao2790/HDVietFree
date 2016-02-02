//
//  NavigationMovieCustomController.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/2/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationMovieCustomController : UINavigationController
@property (nonatomic, strong) UITextField *txtSearch;

/*
 * Init text field
 */
- (void)initTextField;
@end
