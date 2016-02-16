//
//  ListMenuController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/16/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "ListMenuController.h"

@interface ListMenuController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbvListMenu;

@end

@implementation ListMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tbvListMenu.delegate = self;
    self.tbvListMenu.dataSource = self;
    self.tbvListMenu.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvListMenu.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([MovieSearch share].genreMovie == kGenrePhimLe) {
        self.dictMenu = kDicMainMenu;
    } else {
        self.dictMenu = kDicMainMenuPhimBo;
    }

    [self.tbvListMenu reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//*****************************************************************************
#pragma mark -
#pragma mark - ** Table view delegate **

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dictMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"MenuIndentifier";
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dictMenu.allValues[indexPath.row];
    cell.textLabel.textColor = [ UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) { [tableView setSeparatorInset:UIEdgeInsetsZero]; }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) { [tableView setLayoutMargins:UIEdgeInsetsZero]; }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { [cell setLayoutMargins:UIEdgeInsetsZero]; }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end
