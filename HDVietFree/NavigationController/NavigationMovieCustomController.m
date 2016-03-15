//
//  NavigationMovieCustomController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/2/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "NavigationMovieCustomController.h"

@interface NavigationMovieCustomController ()<UITextFieldDelegate>

@end

@implementation NavigationMovieCustomController
@synthesize searchController;

//*****************************************************************************
#pragma mark -
#pragma mark - ** Life Cycle Method **

+ (NavigationMovieCustomController *)share {
    static dispatch_once_t once;
    static NavigationMovieCustomController *share;
    dispatch_once(&once, ^{
        share = [self new];
    });
    return share;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self widenTextField];
}

- (void)widenTextField {
    float y = 0;
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation))
    {
        y = kPositionYTextField;
    } else {
        if (kDeviceIpad) {
            y = kPositionYTextField;
        }
    }
    NSInteger widthTextField = [Utilities widthOfScreen] - kSpaceWidthTextField;
    CGRect frameTextField = CGRectMake([Utilities widthOfScreen] - widthTextField - kPositionYTextField, y,
                                       widthTextField - kSpaceTrailingWidthTextField, kHeightTextField);
    self.txtSearch.frame = frameTextField;

}


//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

/*
 * Config view
 */
- (void)configView {
    [self initTextField];
    searchController = nil;
     [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    
}

/*
 * Init text field
 */
- (void)initTextField {
    NSInteger widthTextField = [Utilities widthOfScreen] - kSpaceWidthTextField;
    CGRect frameTextField = CGRectMake([Utilities widthOfScreen] - widthTextField - kPositionYTextField, kPositionYTextField,
                                       widthTextField - kSpaceTrailingWidthTextField, kHeightTextField);
    self.txtSearch = [[UITextField alloc]initWithFrame:frameTextField];
    self.txtSearch.backgroundColor = [UIColor whiteColor];
    [self.txtSearch setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.txtSearch.delegate = self;
    self.txtSearch.placeholder = kSearchMovie;
    self.txtSearch.textAlignment=NSTextAlignmentCenter;
    self.txtSearch.layer.cornerRadius = kCornerRadius;
    self.txtSearch.layer.masksToBounds = YES;
    self.txtSearch.returnKeyType = UIReturnKeySearch;
    
    // Init right button
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:sizeDeleteNav];
    [deleteButton setImage:[UIImage imageNamed:kDeleteImage] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    self.txtSearch.rightView = deleteButton;
    
    [self.navigationBar addSubview:self.txtSearch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextFieldTextDidChangeNotification object:self.txtSearch];
}

- (void)deleteAction {
    if (searchController) {
        [self.txtSearch resignFirstResponder];
    }
    
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Text field delegate **

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![[self getChildRootViewController] isKindOfClass:[SearchController class]]) {
        searchController = InitStoryBoardWithIdentifier(kSearchController);
        [self pushViewController:searchController animated:YES];
    }

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self deleteAction];
    return YES;
}

-(void)textDidChange:(NSNotification *)notification {
//    UITextField *searchText = [notification object];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeySearch) {
        if (![textField.text isEqualToString:kEmptyString]) {
            ProgressBarShowLoading(kLoading);
            [[ManageAPI share] searchMovieWithKeyword:textField.text];
        }
    }
    
    return [textField resignFirstResponder];
}

/*
 * Get child root view controller
 */
- (UIViewController*) getChildRootViewController {
    NSArray *s_viewController = @[kEpisodeController,
                                  kPlayController,
                                  kSearchController];
    for (NSString *stringViewController in s_viewController) {
        if ([self.topViewController isKindOfClass:NSClassFromString(stringViewController)]) {
            return self.topViewController;
        }
    }
    
    return nil;
}

@end
