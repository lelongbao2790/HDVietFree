//
//  Macro.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

// Detect device
#define kDeviceIsPhoneSmallerOrEqual35 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) <= 480.0)
#define kDeviceIsPhoneSmallerOrEqual40 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) <= 568.0)
#define kDeviceIsPhoneSmallerOrEqual47 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) <= 667.0)
#define kDeviceIsPhoneSmallerOrEqual55 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) <= 1104.0)
#define kDeviceIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// Init storyboard
#define InitStoryBoardWithIdentifier(identifier) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier]

// Progress Bar
#define ProgressBarShowLoading(_Title_) [SNLoading showWithTitle:_Title_]
#define ProgressBarDismissLoading(_Title_) [SNLoading hideWithTitle:_Title_]
#define ProgressBarUpdateLoading(_Title_, _DetailsText_) [SNLoading updateWithTitle:_Title_ detailsText:_DetailsText_]

// String
#define stringFromInteger(value) [NSString stringWithFormat:@"%d", (int)value]
#define numberToInteger(value) [value integerValue]
#define dictToArray(value) [Utilities getObjectResponse:value]
#define getChildController [[NavigationMovieCustomController share] getChildRootViewController]
#define getDictTitleMenu(value) (value == kGenrePhimLe) ? kDicMainMenu: kDicMainMenuPhimBo
#define stringToAccent(value) CFBridgingRelease( CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (__bridge CFStringRef)value, NULL, NULL, kCFStringEncodingUTF8 ) )
#define errorString(value) [[error localizedDescription] isEqualToString:value]

#endif /* Macro_h */
