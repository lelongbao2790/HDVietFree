//
//  Utilities.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/21/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "Utilities.h"
#define kTimeDuration 300

@interface Utilities ()
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation Utilities

static NSInteger timePlay;
BOOL playbackDurationSet=NO;
MPMoviePlayerController *mediaPlayerController = nil;

+ (nonnull Utilities *)share {
    static dispatch_once_t once;
    static Utilities *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

/**
 * fix auto layout for iPhone 5/5S, iPhone 6/6S, iPhone 6/6S Plus
 */
+ (void) fixAutolayoutWithDelegate:(nonnull id /*<UIFixAutolayoutDelegate>*/)delegate {
    static SEL s_selector = nil;
    if (!s_selector) {
        if (kDeviceIsPhoneSmallerOrEqual35) {
            s_selector = NSSelectorFromString(kFixAutoLayoutForIp4);
        } else if (kDeviceIsPhoneSmallerOrEqual40) {
            s_selector = NSSelectorFromString(kFixAutoLayoutForIp5);
        } else if (kDeviceIsPhoneSmallerOrEqual47) {
            s_selector = NSSelectorFromString(kFixAutoLayoutForIp6);
        } else if (kDeviceIsPhoneSmallerOrEqual55) {
            s_selector = NSSelectorFromString(kFixAutoLayoutForIp6Plus);
        } else if (kDeviceIpad) {
            s_selector = NSSelectorFromString(kFixAutoLayoutForIpad);
        }
    }
    
    id<FixAutolayoutDelegate> realDelegate = delegate;
    if ([realDelegate respondsToSelector:s_selector]) {
        IMP imp = [delegate methodForSelector:s_selector];
        void (*func)(id, SEL) = (void *)imp;
        func(realDelegate, s_selector);
    }
}

/**
 * Show iToast message for informing.
 * @param message
 */
+ (void)showiToastMessage:(nonnull NSString *)message
{
    
    iToastSettings *theSettings = [iToastSettings getSharedSettings];
    theSettings.duration = kTimeDuration;
    
    // Prevent crash with null string
    if (message == (id)[NSNull null]) {
        message = kEmptyString;
    }
    
    [[[[iToast makeText:message]
       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
}

/*
 * Save image
 */
+ (void)saveImage:(nonnull UIImage*)image withName:(nonnull NSString *)nameImage {
    if (image !=nil && nameImage!=nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithString: nameImage]];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

/*
 * Get srt file from url
 */
+ (nonnull NSString*)getDataSubFromUrl:(nonnull NSString*)srtUrl {
    NSString *sub = kEmptyString;
    NSURL  *url = [NSURL URLWithString:srtUrl];
    NSData *urlData = [[NSData alloc] initWithContentsOfURL:url] ;
    if ( urlData )
    {
        sub = [NSString stringWithUTF8String:[urlData bytes]];
    }
    return sub;
}

/*
 * Load image
 */
+ (nonnull UIImage*)loadImageFromName:(nonnull NSString *)nameImage {
    UIImage* image = nil;
    if (nameImage) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithString: nameImage] ];
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

/*
 * Check image exist
 */
+ (BOOL)isExistImage:(nonnull NSString *)nameImage {
    if (nameImage) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithString: nameImage] ];
        
        return [[NSFileManager defaultManager] fileExistsAtPath:path];
    } else {
        return NO;
    }
    
}

/*
 * Set main page
 */
+ (void)setMainPageSlide {
    
    // Set main panel
    SlideMenuController *leftMenu = InitStoryBoardWithIdentifier(kSlideMenuController);
    MainController *mainController = InitStoryBoardWithIdentifier(kMainController);
    
    [AppDelegate share].mainPanel = [JASidePanelController shareInstance];
    [AppDelegate share].mainPanel.leftPanel = leftMenu;
    [AppDelegate share].mainPanel.centerPanel = [[NavigationMovieCustomController alloc] initWithRootViewController:mainController];
    [AppDelegate share].window.rootViewController = [AppDelegate share].mainPanel;
}

/*
 * Get year from date
 */
+ (nonnull NSString *)getYearOfDateFromString:(nonnull NSString *)strDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
    
    return [NSString stringWithFormat:@"%d",(int)[components year]];
}

/*
 * Get string url poster image
 */
+ (nonnull NSString *)getStringUrlPoster:(nonnull Movie *)movie {
    if ([movie.poster containsString:kUrlHttpTHdViet]) {
        return movie.poster;
    } else {
        return [NSString stringWithFormat:kUrlImagePosterHdViet, movie.poster];
    }
}

/*
 * Get width of screen
 */
+ (CGFloat)widthOfScreen {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return  screenRect.size.width;
}

/*
 * Height of screen
 */
+ (CGFloat)heightOfScreen {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height;
}

/*
 * Cache Image
 */
- (void)cacheImage:(nonnull UIImage*)image forKey:(nonnull NSString*)key {
    [self.imageCache setObject:image forKey:key];
}

/*
 * Get image
 */
-  (nonnull UIImage*)getCachedImageForKey:(nonnull NSString*)key {
    return [self.imageCache objectForKey:key];
}

+ (NSDictionary * _Nullable )convertNullDictionary:(NSDictionary * _Nullable )dict {
    if ([dict isKindOfClass:[NSNull class]]) {
        return nil;
    }else {
        return dict;
    }
}

/*
 * Play media controller
 */
+ (void)playMediaLink:(nonnull NSString *)linkPlay
               andSub:(nonnull NSString *)linkSub
        andController:(nonnull UIViewController *)controller {
    if (linkPlay && linkSub) {
        NSURL *url = [[NSURL alloc] initWithString:linkPlay];
         MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        mediaPlayerController = player.moviePlayer;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerLoadStateDidChange:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
        
        //Add Absorver
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerPlaybackStateChanged:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:player.moviePlayer];
        player.view.tag = kTagMPMoviePlayerController;
        player.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
        player.moviePlayer.view.transform = CGAffineTransformConcat(player.moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
        [player.moviePlayer.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        NSString *subString = [Utilities getDataSubFromUrl:linkSub];
        [player.moviePlayer openWithSRTString:subString completion:^(BOOL finished) {
            // Activate subtitles
            [player.moviePlayer showSubtitles];
            
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error.description);
            
            [Utilities showiToastMessage:@"Phim này hiện chưa có sub việt"];
        }];
        
        // Present video
        kMoviePlayer = player;
        [controller presentMoviePlayerViewControllerAnimated:player];
        [player.moviePlayer prepareToPlay];
        [player.moviePlayer play];
    } else {
        [Utilities showiToastMessage:@"Phim này hiện chưa có link"];
    }
   
}

+ (void)moviePlaybackDidFinish:(nonnull NSNotification*)aNotification{
    
    NSError *error = [[aNotification userInfo] objectForKey:@"error"];
    if (error) {
        [Utilities showiToastMessage:kErrorPlayMovie];
    }
    
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonUserExited) {
        if ([getChildController isKindOfClass:[PlayController class]] ||
            [getChildController isKindOfClass:[EpisodeController class]] ) {
            [getChildController dismissMoviePlayerViewControllerAnimated];
            kMoviePlayer = nil;
            [Utilities resetPlayerDurationVar];
        } else {
            kMoviePlayer = nil;
            [Utilities resetPlayerDurationVar];
        }
    } else {
        kMoviePlayer = nil;
        [Utilities resetPlayerDurationVar];
    }
}
+ (void)moviePlayerPlaybackStateChanged:(NSNotification*)notification{
    MPMoviePlayerController* player = (MPMoviePlayerController*)notification.object;
    
    switch ( player.playbackState ) {
        case MPMoviePlaybackStatePlaying:
            
            if(!playbackDurationSet){
                [mediaPlayerController setCurrentPlaybackTime:player.initialPlaybackTime];
                playbackDurationSet=YES;
            }
            break;
            
        default:
            break;
    }
}

+ (void)resetPlayerDurationVar{
    playbackDurationSet=NO;
}

+ (void)moviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if ([getChildController isKindOfClass:[PlayController class]] ||
        [getChildController isKindOfClass:[EpisodeController class]] ) {
        
        if([kMoviePlayer.moviePlayer loadState] != MPMovieLoadStateUnknown)
        {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerLoadStateDidChangeNotification
                                                          object:nil];
        }
    }
}


// Call this on applicationWillResignActive
+ (void) pauseMovieInBackGround
{
    if (kMoviePlayer) {
        [kMoviePlayer.moviePlayer pause];
        timePlay = round([kMoviePlayer.moviePlayer currentPlaybackTime]);
        [getChildController dismissMoviePlayerViewControllerAnimated];
    }
}

// Call this on applicationWillEnterForeground
+ (void) resumeMovieInFrontGround:(UIViewController *)controller
{
    if (kMoviePlayer) {
        DLOG(@"Time resume: %d",(int)timePlay);
        [controller presentMoviePlayerViewControllerAnimated:kMoviePlayer];
        
        [kMoviePlayer.moviePlayer prepareToPlay];
        [kMoviePlayer.moviePlayer play];
//        [kMoviePlayer.moviePlayer setInitialPlaybackTime:-1];
        [kMoviePlayer.moviePlayer setCurrentPlaybackTime:timePlay];

    }
}


+ (nonnull NSArray *)sortArrayFromDict:(nonnull NSDictionary *)dict {
    NSArray *reverseOrder=[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return reverseOrder;
}

+ (void)alertMessage:(nonnull NSString*)message withController:(nonnull UIViewController *)controller
{
    if ([message isEqualToString:kInvalidSession]) {
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:@"Lỗi"
                                    message:message
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction
                                        actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
                                            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[AppDelegate share].loginController];
                                            [AppDelegate share].window.rootViewController = navController;
                                        }];
        
        [alert addAction:defaultAction];
        [controller presentViewController:alert animated:YES completion:nil];
    } else {
        [Utilities showiToastMessage:message];
    }
}

+ (void)setColorOfSelectCell:(nonnull UITableViewCell *)cell {
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithHexString:kColorBgNavigationBar];
    [cell setSelectedBackgroundView:bgColorView];
}

+ (BOOL)isEmptyArray:(nonnull NSArray *)listArray {
    if (listArray.count > 0)
        return NO;
    else
        return YES;
}

+ (void)loadServerFail:(nonnull UIViewController *)controller withResultMessage:(nonnull NSString *)resultMessage {
    ProgressBarDismissLoading(kEmptyString);
    [Utilities alertMessage:resultMessage withController:controller];
}

+ (nonnull NSArray *)getObjectResponse:(nonnull NSDictionary *)response {
    // Get object response
    NSMutableArray *listResponse = [[NSMutableArray alloc] init];
    NSArray *listData = [response objectForKey:kList];
    NSInteger totalRecord = [[[response objectForKey:kMetadata] objectForKey:kTotalRecord] integerValue];
    NSInteger pageResponse = [[[response objectForKey:kMetadata] objectForKey:kPage] integerValue];
    NSInteger genreNumber = [[[response objectForKey:kMetadata] objectForKey:kGenre] integerValue];
    NSString *tagMovie = [[response objectForKey:kMetadata] objectForKey:kTag];
    
    // Set object response
    [listResponse addObject:listData];
    [listResponse addObject:[NSNumber numberWithInteger:totalRecord]];
    [listResponse addObject:[NSNumber numberWithInteger:pageResponse]];
    [listResponse addObject:[NSNumber numberWithInteger:genreNumber]];
    [listResponse addObject:tagMovie];
    return listResponse;
}

+ (BOOL)isLastListCategory:(nonnull NSDictionary *)dictCategory andCurrentIndex:(NSInteger)currentIndex andLoop:(BOOL)loop {
    if (loop) {
        if (currentIndex == dictCategory.allKeys.count*2 - 1) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if (currentIndex == dictCategory.allKeys.count - 1)
            return YES;
        else
            return NO;
    }
}

+ (nonnull FilmController *)initFilmControllerWithTag:(nonnull NSString *)nameTag numberTag:(NSInteger)numberTag andListDb:(nonnull NSArray *)listDb {
    FilmController *filmController = InitStoryBoardWithIdentifier(kFilmController);
    filmController.view.tag = numberTag;
    filmController.tagMovie = nameTag;
    filmController.listMovie = [[NSMutableArray alloc] initWithArray:listDb];
    filmController.totalItemOnOnePage = listDb.count;
    return filmController;
}

+ (void)writeToPlist:(nonnull NSString *)stringWrite
{
    NSString *myFile = @"crashed.plist";
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [filePaths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:myFile];
    
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [plistDict setValue:stringWrite forKey:@"Crashed"];
    [plistDict writeToFile:path atomically: YES];
}

+ (BOOL)isCrashApp
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:kConsoleLog];
    NSData *myData = [NSData dataWithContentsOfFile:logPath];
    
    if (myData) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)removeCrashLogFileAtPath:(nonnull NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = path;
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        DLOG(@"Remove log success");
    }
    else
    {
        DLOG(@"Can not remove log success");
    }
}


+ (nonnull id)nullToObject:(nonnull NSDictionary *)dict key:(nonnull NSString *)key andType:(NSInteger)type {
    id object = [dict objectForKey:key];
    if ([object isKindOfClass:[NSNull class]]) {
        switch (type) {
            case kTypeString:
                return kEmptyString;
                break;
            
            case kTypeInteger:
                return 0;
                break;
            
            case kTypeArray:
                return nil;
                break;
                
            default:
                return kEmptyString;
                break;
        }
    } else {
        return object;
    }
}

@end
