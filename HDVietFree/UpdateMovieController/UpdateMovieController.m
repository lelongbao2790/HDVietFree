//
//  UpdateMovieController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/15/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "UpdateMovieController.h"

@interface UpdateMovieController ()
@property (weak, nonatomic) IBOutlet UILabel *lbTotalMovie;

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

- (IBAction)btnUpdate:(id)sender {
}

/*
 * Config view
 */
- (void)configView {
    self.lbTotalMovie.text = stringFromInteger([[Movie query] count]);
}

@end
