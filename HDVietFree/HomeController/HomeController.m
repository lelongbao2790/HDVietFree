//
//  HomeController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 3/23/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "HomeController.h"

@interface HomeController ()<FixAutolayoutDelegate, ChooseServerDelegate>

// Property
@property (weak, nonatomic) IBOutlet UIButton *btnWatchMovie;
@property (weak, nonatomic) IBOutlet UIButton *btnTivi;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeightButton;

@end

@implementation HomeController

#pragma Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self config];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Helper Method
- (void)config {
    
    [AppDelegate share].homeController = self;
    
    // Delegate fix autolayout
    [Utilities fixAutolayoutWithDelegate:self];
    
    // Customize button
    [self customizeButton];
}

/*
 * Customize button
 */
- (void)customizeButton {
    [Utilities setBorderView:self.btnWatchMovie];
    [Utilities setBorderView:self.btnTivi];
    [Utilities setBorderView:self.btnSetting];
    [Utilities setBorderView:self.btnReport];
}

#pragma IBAction
- (IBAction)btnWatchMovie:(id)sender {
    ChooseServerController *chooseServer = InitStoryBoardWithIdentifier(kChooseServerController);
    chooseServer.delegate = self;
    [self presentViewController:chooseServer animated:YES completion:nil];
    
}

- (IBAction)btnTivi:(id)sender {
    
    TVChannelController *tvChannelController = [AppDelegate share].tvChannelController;
    tvChannelController.navigationItem.leftBarButtonItem = nil;
    [self.navigationController pushViewController:tvChannelController animated:YES];
    
}

- (IBAction)btnSetting:(id)sender {
}

- (IBAction)btnReport:(id)sender {
}

#pragma Choose Server Delegate

- (void)actionDeleteController:(ChooseServerController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionHDOController:(ChooseServerController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionHdvietController:(ChooseServerController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self moveToLogin];
}

/*
 * Move to form login
 */
- (void)moveToLogin {
    LoginController *loginController = InitStoryBoardWithIdentifier(kLoginController);
    [self.navigationController pushViewController:loginController animated:YES];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {

}

- (void)fixAutolayoutFor40 {

}

- (void)fixAutolayoutFor47 {
    self.csHeightButton.constant = kHeightButtonHomeIpad;
}

- (void)fixAutolayoutFor55 {
    self.csHeightButton.constant = kHeightButtonHomeIpad;
}

-(void)fixAutolayoutForIpad {
    self.csHeightButton.constant = kHeightButtonHomeIpad;
}

@end
