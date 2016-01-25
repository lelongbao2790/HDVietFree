//
//  LoginController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/21/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "LoginController.h"

@interface LoginController () <LoginDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

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
    [DataManager shared].loginDelegate = self;
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
    ProgressBarShowLoading(@"Loading");
    [[ManageAPI share] loginAPI:self.txtUsername.text andPass:self.txtPassword.text];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Login delegate **

- (void)loginAPISuccess:(NSDictionary *)response {
    ProgressBarDismissLoading(kEmptyString);
    
    User *aUser = [User userFromJSON:response];
    
    // Save access token
    [[NSUserDefaults standardUserDefaults] setObject:aUser.accessToken forKey:kAccessToken];
    
    MainController *mainController = InitStoryBoardWithIdentifier(kMainController);
    [self.navigationController pushViewController:mainController animated:YES];
    
}

- (void)loginAPIFail:(NSString *)resultMessage {
    
}

@end
