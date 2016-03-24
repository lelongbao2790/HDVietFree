//
//  UpdateMovieController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/15/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "UpdateMovieController.h"

@interface UpdateMovieController ()<ListMovieByGenreDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbTotalMovie;
@property (assign, nonatomic) NSInteger lastListMovie;
@property (strong, nonatomic) NSDictionary *dictMenu;
@end

@implementation UpdateMovieController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [DataManager shared].listMovieDelegate = self;
    [self.navigationController.navigationBar setHidden:NO];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

/*
 * Config view
 */
- (void)configView {
    [self updateTotalMovie];
    
    self.title = [kUpdateData uppercaseString];
     self.dictMenu = getDictTitleMenu([MovieSearch share].genreMovie);
}

/*
 * Update label movie
 */
- (void)updateTotalMovie {
    self.lbTotalMovie.text = stringFromInteger([[Movie query] count]);
}

- (void)requestUpdateMovie {
    ProgressBarShowLoading(kLoading);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        // Download
        [[[Movie query] fetch] removeAll];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.lastListMovie = 0;
            DLOG(@"Total menu : %d", (int)kDicMainMenu.allKeys.count);
            
            for (int i = 0; i < self.dictMenu.allKeys.count; i++) {
                // Not exist - Request server to get list
                [[ManageAPI share] loadListMovieAPI:kGenrePhimLe tag:self.dictMenu.allKeys[i] andPage:kPageDefault];
                [[ManageAPI share] loadListMovieAPI:kGenrePhimBo tag:self.dictMenu.allKeys[i] andPage:kPageDefault];
            }
        });
    });
}

- (IBAction)btnUpdate:(id)sender {
    
    if ([self checkAccessTokenSave]) {
        [self requestUpdateMovie];
    } else {
        
        NSString *accessTokenHDV = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
        NSString *accessTokenHDO = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenHDO];
        
        UIAlertController* alert;
        if (!accessTokenHDV) {
            alert = [UIAlertController alertControllerWithTitle:kAlertTitle message:kErrorAccessTokenHDViet
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            
        }
        else if (!accessTokenHDO){
            alert = [UIAlertController alertControllerWithTitle:kAlertTitle
                                                        message:kErrorAccessTokenHDO
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
        }
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.placeholder = NSLocalizedString(@"Username", @"Username");
         }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.placeholder = NSLocalizedString(@"Password", @"Password");
             textField.secureTextEntry = YES;
         }];
        
        UIAlertAction* defaultAction = [UIAlertAction
                                        actionWithTitle:kOK style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            UITextField *login = alert.textFields.firstObject;
                                            UITextField *password = alert.textFields.lastObject;
                                            
                                            // Login server
                                            if (![login.text isEqualToString:kEmptyString] &&
                                                ![password.text isEqualToString:kEmptyString]) {
                                                [self.view endEditing:YES];
                                                ProgressBarShowLoading(kLoading);
                                                [[ManageAPI share] loginAPI:login.text andPass:password.text];
                                            } else {
                                                [Utilities showiToastMessage:@"Nhập username và password"];
                                            }
                                        }];
        
        [alert addAction:defaultAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self.view endEditing:YES];
                                           NSLog(@"Cancel action");
                                       }];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

- (BOOL)checkAccessTokenSave {
    
    NSString *accessTokenHDV = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    NSString *accessTokenHDO = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenHDO];
    if (accessTokenHDV && accessTokenHDO) {
        [UserHDV share].accessToken = accessTokenHDV;
        [UserHDV share].userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
        return YES;
    } else {
        return NO;
    }
    
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** List movie delegate **

- (void)loadListMovieAPISuccess:(NSDictionary *)response atTag:(NSString *)tagMovie andGenre:(NSString *)genre {
    
    // Add list movie to local
    [[DataAccess share] addListMovieToLocal:response];
    
    // Check last list category
    if ([Utilities isLastListCategory:self.dictMenu andCurrentIndex:self.lastListMovie andLoop:YES]) {
        // Last list loaded
        ProgressBarDismissLoading(kEmptyString);
        self.lastListMovie = 0;
        [Utilities showiToastMessage:kUpdateMovieSuccess];
        [self updateTotalMovie];
    } else {
        self.lastListMovie += 1;
    }
}

- (void)loadListMovieAPIFail:(NSString *)resultMessage {
    [Utilities loadServerFail:self withResultMessage:resultMessage];
}

@end
