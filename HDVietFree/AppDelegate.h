//
//  AppDelegate.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/21/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateMovieController.h"
#import "ReportBugController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//*****************************************************************************
#pragma mark -
#pragma mark ** Life Cycle **

+ (AppDelegate *)share;

//*****************************************************************************
#pragma mark -
#pragma mark ** Property **
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *mainPanel;
@property (strong, nonatomic) MainController *mainController;
@property (strong, nonatomic) LoginController *loginController;
@property (strong, nonatomic) UpdateMovieController *updateMovieController;
@property (strong, nonatomic) ReportBugController *reportBugController;
@end

