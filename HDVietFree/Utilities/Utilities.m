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

+ (Utilities *)share {
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
    if (image != nil)
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: nameImage] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
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

// set
- (void)cacheImage:(nonnull UIImage*)image forKey:(nonnull NSString*)key {
    [self.imageCache setObject:image forKey:key];
}
// get
-  (nonnull UIImage*)getCachedImageForKey:(nonnull NSString*)key {
    return [self.imageCache objectForKey:key];
}

@end
