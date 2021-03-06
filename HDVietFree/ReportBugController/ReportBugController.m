//
//  ReportBugController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/17/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "ReportBugController.h"

@interface ReportBugController ()<ReportBugDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tvReport;

@end

@implementation ReportBugController

//*****************************************************************************
#pragma mark -
#pragma mark - ** Life Cycle **

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [DataManager shared].reportBugDelegate = self;
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

- (void)configView {
    // Init
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnView)];
    tapGesture.cancelsTouchesInView = NO;
    [[AppDelegate share].window addGestureRecognizer:tapGesture];
    
    // Customize color of text view
    self.tvReport.layer.borderWidth = 1.0;
    self.tvReport.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.title = kReportAppTitle;
}

- (void)tapOnView {
    [self.view endEditing:YES];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Text View Delegate **

- (IBAction)btnSubmit:(id)sender {
    if (self.tvReport.text.length > 0) {
        ProgressBarShowLoading(kLoading);
        [[DataManager shared] reportBugWithData:[NSString stringWithFormat:kBugDescription, self.tvReport.text]];
    } else {
        [Utilities showiToastMessage:kInputErrorString];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Report Bug Delegate **

- (void)reportBugAPIFail:(NSString *)resultMessage {
    ProgressBarDismissLoading(kEmptyString);
    [Utilities showiToastMessage:kReportFail];
}

- (void)reportBugAPISuccess:(NSDictionary *)response {
    ProgressBarDismissLoading(kEmptyString);
    [Utilities showiToastMessage:kReportSuccess];
    self.tvReport.text = kEmptyString;
}

@end
