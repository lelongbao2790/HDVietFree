//
//  AppDelegate.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/21/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<DBDelegate>

@end

@implementation AppDelegate

//*****************************************************************************
#pragma mark -
#pragma mark ** Life Cycle **

+ (AppDelegate *)share
{
    static dispatch_once_t once;
    static AppDelegate *share;
    
    dispatch_once(&once, ^{
        share = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    });
    return share;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:kColorBgNavigationBar]];
    [self connectLocalDatabase];
    [self handleLogin];
    [self setCustomNavigationBackButton];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Helper Method **
- (void)connectLocalDatabase {
    [DBAccess setDelegate:self];
    [DBAccess openDatabaseNamed:kNameDatabase];
}
- (void)setCustomNavigationBackButton
{
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithHexString:kTextColorOfTitleNav]}];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:kTextColorOfTitleNav]];
}

- (void)handleLogin {
    if ([self checkAccessTokenSave]) {
        [Utilities setMainPageSlide];
    } else {
        LoginController *loginController = InitStoryBoardWithIdentifier(kLoginController);
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        self.window.rootViewController = navController;
    }
}

- (BOOL)checkAccessTokenSave {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];

    if (accessToken) {
        [User share].accessToken = accessToken;
        [User share].userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        return YES;
    } else {
        return NO;
    }
    
//    return NO;
}

@end
