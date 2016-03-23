//
//  ChooseServerController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/23/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "ChooseServerController.h"

@interface ChooseServerController ()<FixAutolayoutDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeightButtonChooseServer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csWidthButtonChooseServer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeightViewButton;

@end

@implementation ChooseServerController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Helper Method
- (void)config {
    // Delegate fix autolayout
    [Utilities fixAutolayoutWithDelegate:self];
    
    [Utilities setBorderView:self.viewButton];
}

#pragma IBAction

- (IBAction)btnDelete:(id)sender {
    
    if ([delegate respondsToSelector:@selector(actionDeleteController:)]) {
        [delegate actionDeleteController:self];
    }
}
- (IBAction)btnHDViet:(id)sender {
    if ([delegate respondsToSelector:@selector(actionDeleteController:)]) {
        [delegate actionHdvietController:self];
    }
}
- (IBAction)btnHDO:(id)sender {
    if ([delegate respondsToSelector:@selector(actionDeleteController:)]) {
        [delegate actionHDOController:self];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {

}

- (void)fixAutolayoutFor40 {
    
}

- (void)fixAutolayoutFor47 {
    
}

- (void)fixAutolayoutFor55 {
    
}

-(void)fixAutolayoutForIpad {
    self.csHeightButtonChooseServer.constant = kHeightButtonChooseServerIpad;
    self.csWidthButtonChooseServer.constant = kHeightButtonChooseServerIpad;
    self.csHeightViewButton.constant = kHeightViewButtonChooseServerIpad;
}
@end
