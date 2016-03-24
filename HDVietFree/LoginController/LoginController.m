//
//  LoginController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/21/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "LoginController.h"
#import <MessageUI/MessageUI.h>

@interface LoginController () <LoginDelegate, FixAutolayoutDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csTopConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeight;
@property (assign, nonatomic) float topConstant;
@property (assign, nonatomic) BOOL isShowKeyboard;
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
    [DataManager shared].loginDelegate = self;
    [self.navigationController.navigationBar setHidden:NO];
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        self.csTopConstant.constant = -150;
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
        // revert back to the normal state.
        self.csTopConstant.constant = self.topConstant;
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (!self.isShowKeyboard) {
        [self setViewMovedUp:YES];
        self.isShowKeyboard = YES;
    }
}

-(void)keyboardWillHide {
    if (self.isShowKeyboard) {
        [self setViewMovedUp:NO];
        self.isShowKeyboard = NO;
    }
}


/*
 * Config
 */
- (void)configView {
    self.user = [User share];
    
    [AppDelegate share].loginController = self;
    [Utilities fixAutolayoutWithDelegate:self];
    [self handleLogin];
    self.topConstant = self.csTopConstant.constant;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnView)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapOnView {
    [self.view endEditing:YES];
    // revert back to the normal state.
    self.csTopConstant.constant = self.topConstant;
    [self setViewMovedUp:NO];
}

/*
 * Method handle login app with token
 */
- (void)handleLogin {
    if (![Utilities isCrashApp]) {
        if ([ServerType isSaveToken]) {
            [Utilities setMainPageSlide];
        }
    } else {
        [self presentCrashApp];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Handle Crashed **

/*
 * Method show crash log
 */
- (void)presentCrashApp {
    if ([MFMailComposeViewController canSendMail]) {
        
        // Get data log
        // Attach the Crash Log..
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *logPath = [documentsDirectory stringByAppendingPathComponent:kConsoleLog];
        NSData *myData = [NSData dataWithContentsOfFile:logPath];
        
        // Init mail compose
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:kCrashTitle];
        [mailViewController setMessageBody:[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding] isHTML:NO];
        NSArray *toRecipients = [NSArray arrayWithObject:kEmailSendCrash];
        [mailViewController setToRecipients:toRecipients];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
        [Utilities removeCrashLogFileAtPath:logPath];
    }
    
    else {
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if ([ServerType isSaveToken]) {
        [Utilities setMainPageSlide];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Text field delegate **

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.txtPassword) {
        if (textField.returnKeyType == UIReturnKeyDone) {
            [self loginServer];
        }
    }
    
    return [textField resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** IBAction **
- (IBAction)btnLogin:(id)sender {
    [self loginServer];
    
}

- (void)loginServer {
    if (![self.txtUsername.text isEqualToString:kEmptyString] &&
        ![self.txtPassword.text isEqualToString:kEmptyString]) {
        [self.view endEditing:YES];
        ProgressBarShowLoading(kLoading);
        [[ManageAPI share] loginAPI:self.txtUsername.text andPass:self.txtPassword.text];
    } else {
        [Utilities showiToastMessage:@"Nhập username và password"];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Login delegate **

- (void)loginAPISuccess:(NSDictionary *)response {
    ProgressBarDismissLoading(kEmptyString);
    self.user = [User userFromJSON:response];
    
    [Utilities setMainPageSlide];
    
}

- (void)loginAPIFail:(NSString *)resultMessage {
     [Utilities loadServerFail:self withResultMessage:resultMessage];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {
    self.csTopConstant.constant = kTopConstantIp4;
}

- (void)fixAutolayoutFor40 {
    self.csTopConstant.constant = kTopConstantIp5;
}

- (void)fixAutolayoutFor47 {
    self.csTopConstant.constant = kTopConstantIp6;
    self.csLeading.constant = kLeadingConstantLogin;
    self.csTrailing.constant = kLeadingConstantLogin;
}

- (void)fixAutolayoutFor55 {
    self.csTopConstant.constant = kTopConstantIp6Plus;
    self.csLeading.constant = kLeadingConstantLogin;
    self.csTrailing.constant = kLeadingConstantLogin;
}

-(void)fixAutolayoutForIpad {
    self.csTopConstant.constant = kTopConstantIpad;
    self.csLeading.constant = kTopConstantIpad;
    self.csTrailing.constant = kTopConstantIpad;
//    self.csHeight.constant = kTopConstantIpad;
}

@end
