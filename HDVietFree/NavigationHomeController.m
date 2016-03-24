//
//  NavigationHomeController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/23/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "NavigationHomeController.h"

@interface NavigationHomeController ()

@end

@implementation NavigationHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (BOOL)shouldAutorotate {
//    id currentViewController = self.topViewController;
//    
//    if ([currentViewController isKindOfClass:[HomeController class]])
//        return NO;
//    
//    return YES;
//}

- (BOOL)shouldAutorotate
{
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    id currentViewController = self.topViewController;
    
    if ([currentViewController isKindOfClass:[HomeController class]])
        return UIInterfaceOrientationMaskPortrait;
    
    return UIInterfaceOrientationMaskAll;
}

@end
