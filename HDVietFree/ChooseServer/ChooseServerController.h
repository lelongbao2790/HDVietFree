//
//  ChooseServerController.h
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/23/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseServerDelegate;

@interface ChooseServerController : UIViewController
@property (nonatomic, weak) id<ChooseServerDelegate> delegate;
@end

@protocol ChooseServerDelegate <NSObject>

- (void)actionDeleteController:(ChooseServerController *)controller;
- (void)actionHdvietController:(ChooseServerController *)controller;
- (void)actionHDOController:(ChooseServerController *)controller;

@end
