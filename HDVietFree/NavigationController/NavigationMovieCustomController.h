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
@property (strong, nonatomic) SearchController *searchController;
/*
 * Init text field
 */
- (void)initTextField;

/*
 * Get child root view controller
 */
- (UIViewController*) getChildRootViewController;

+ (NavigationMovieCustomController *)share;

@end
