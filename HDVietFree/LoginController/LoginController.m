//
//  LoginController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/21/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "LoginController.h"

@interface LoginController () <LoginDelegate, FixAutolayoutDelegate>

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csTopConstant;

@end

@implementation LoginController

//*****************************************************************************
#pragma mark -
#pragma mark - ** Life Cycle **

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // Hidden navigation bar
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **
/*
 * Config
 */
- (void)configView {
    self.user = [User share];
    [DataManager shared].loginDelegate = self;
    [AppDelegate share].loginController = self;
    [self handleLogin];
    [Utilities fixAutolayoutWithDelegate:self];
}

- (void)handleLogin {
    if ([self checkAccessTokenSave]) {
        [Utilities setMainPageSlide];
    }
}

- (BOOL)checkAccessTokenSave {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    
    if (accessToken) {
        [User share].accessToken = accessToken;
        [User share].userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        self.txtUsername.text = [User share].userName;
        self.txtPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
        return YES;
    } else {
        return NO;
    }
    
    //    return NO;
}


//*****************************************************************************
#pragma mark -
#pragma mark - ** Text field delegate **

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** IBAction **
- (IBAction)btnLogin:(id)sender {
    [self.view endEditing:YES];
    ProgressBarShowLoading(kLoading);
    [[ManageAPI share] loginAPI:self.txtUsername.text andPass:self.txtPassword.text];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Login delegate **

- (void)loginAPISuccess:(NSDictionary *)response {
    ProgressBarDismissLoading(kEmptyString);
    
    self.user = [User userFromJSON:response];
    
    // Save access token
    [[NSUserDefaults standardUserDefaults] setObject:self.user.accessToken forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:self.user.userName forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:kPassword];
    
    [Utilities setMainPageSlide];
    
}

- (void)loginAPIFail:(NSString *)resultMessage {
     [Utilities loadServerFail:self withResultMessage:resultMessage];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {
    self.csTopConstant.constant = kTopConstantIp5;
}

- (void)fixAutolayoutFor40 {
    self.csTopConstant.constant = kTopConstantIp5;
}

- (void)fixAutolayoutFor47 {
    self.csTopConstant.constant = kTopConstantIp6;
}

- (void)fixAutolayoutFor55 {
    self.csTopConstant.constant = kTopConstantIp6Plus;
}

-(void)fixAutolayoutForIpad {
    self.csTopConstant.constant = kTopConstantIpad;
}

@end
