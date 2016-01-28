//
//  SlideMenuController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "SlideMenuController.h"

@interface SlideMenuController ()<UITableViewDelegate, UITableViewDataSource>

// Property
@property (strong, nonatomic) NSDictionary *dictMenu;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;

// IBOutlet
@property (weak, nonatomic) IBOutlet UITableView *tbvListMenu;

@end

@implementation SlideMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self configView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **
- (void)configView {
    
    // Config table view
    self.tbvListMenu.delegate = self;
    self.tbvListMenu.dataSource = self;
    self.tbvListMenu.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvListMenu.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dictMenu = kDicLeftMenu;
    [self.tbvListMenu reloadData];
    self.nameUser.text = [User share].userName;
}

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
    
    // Init cell
    SlideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewLeftMenuIdentifier];
    if(!cell) { cell = [[SlideMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewLeftMenuIdentifier]; }
    
    [cell setInformationCell:self.dictMenu.allValues[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) { [tableView setSeparatorInset:UIEdgeInsetsZero]; }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) { [tableView setLayoutMargins:UIEdgeInsetsZero]; }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { [cell setLayoutMargins:UIEdgeInsetsZero]; }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Assign tag menu
    [MovieSearch share].genreMovie = [self.dictMenu.allKeys[indexPath.row] integerValue];
    [[AppDelegate share].mainPanel showCenterPanelAnimated:YES];
    [[AppDelegate share].mainController configView];
    
}


@end
