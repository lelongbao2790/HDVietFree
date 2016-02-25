//
//  SlideMenuController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "SlideMenuController.h"

@interface SlideMenuController ()<UITableViewDataSource, UITableViewDelegate>

// Property
@property (strong, nonatomic) NSDictionary *dictMenu;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (strong, nonatomic) NSMutableIndexSet *expandedSections;
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
    self.tbvListMenu.dataSource = self;
    self.tbvListMenu.delegate = self;
    self.tbvListMenu.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbvListMenu.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dictMenu = kDicLeftMenu;
    [self.tbvListMenu reloadData];
    self.nameUser.text = [User share].userName;
    [self.tbvListMenu setAllowsMultipleSelection:YES];
    
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Table view delegate **

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    NSString *stringValue = self.dictMenu.allValues[section];
    if ([stringValue isEqualToString:kPhimLeString] ||
        [stringValue isEqualToString:kPhimBoString]) {
        return YES;
    }
    
    return NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dictMenu.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if (self.expandedIndexPath) {
            
            if (self.expandedIndexPath.section == section) {
                NSString *stringValue = self.dictMenu.allValues[self.expandedIndexPath.section];
                if ([stringValue isEqualToString:kPhimLeString]) {
                    return kDicMainMenu.allValues.count;
                } else if ([stringValue isEqualToString:kPhimBoString]) {
                    return kDicMainMenuPhimBo.allValues.count;
                } else {
                    return 0;
                }
            }
            else {
                return 0;
            }
            
        }
        else {
            return 0;
        }
    }
    
    // Return the number of rows in the section.
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tbvListMenu.frame.size.width, 44)];
    viewHeader.backgroundColor = [UIColor colorWithHexString:kBgColorOfSlideBar];
    viewHeader.tag = section;
    
    // Header label
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 8, self.tbvListMenu.frame.size.width, 28)];
    headerLabel.tag = section+100;
    headerLabel.userInteractionEnabled = YES;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = self.dictMenu.allValues[section];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [viewHeader addSubview:headerLabel];
    
    // Header image
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 25, 25)];
    image.image = [UIImage imageNamed:kDicLeftMenuImage.allValues[section][0]];
    [viewHeader addSubview:image];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHeader:)];
    tapGesture.cancelsTouchesInView = NO;
    [viewHeader addGestureRecognizer:tapGesture];
    
    return viewHeader;

}


- (void)didTapHeader:(UITapGestureRecognizer *)recognizer {
    NSInteger section = recognizer.view.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:recognizer.view.tag];
    NSString *stringValue = self.dictMenu.allValues[section];
    
    if ([stringValue isEqualToString:kLogOut]) {
        [self resetExpandTableView];
        // Log out
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[AppDelegate share].loginController];
        [AppDelegate share].window.rootViewController = navController;
        [[AppDelegate share].window makeKeyAndVisible];
        
    }
    else if ([stringValue isEqualToString:kReportString]) {
        // Report
        [self resetExpandTableView];
        ReportBugController *reportBug = [AppDelegate share].reportBugController;
        [AppDelegate share].mainPanel.centerPanel = [[UINavigationController alloc] initWithRootViewController:reportBug];
        [[AppDelegate share].mainPanel showCenterPanelAnimated:YES];
        [[AppDelegate share].window makeKeyAndVisible];
    }

    else if ([stringValue isEqualToString:kUpdateData]) {
        // Update data movie
        [self resetExpandTableView];
        UpdateMovieController *updateMovie = [AppDelegate share].updateMovieController;
        [AppDelegate share].mainPanel.centerPanel = [[UINavigationController alloc] initWithRootViewController:updateMovie];
        [[AppDelegate share].mainPanel showCenterPanelAnimated:YES];
        [[AppDelegate share].window makeKeyAndVisible];
    }
    
    else if ([stringValue isEqualToString:kPhimLeString] ||
             [stringValue isEqualToString:kPhimBoString]) {
        [MovieSearch share].genreMovie = [self.dictMenu.allKeys[section] integerValue];
        if (self.expandedIndexPath) {
            self.expandedIndexPath = nil;
            [self updateTableView];
        } else {
            self.expandedIndexPath = indexPath;
            [self updateTableView];
        }
    }
    
    else {
        [MovieSearch share].genreMovie = kGenrePhimLe;
        [[AppDelegate share].mainController.tbvListMovie reloadData];
        [AppDelegate share].mainPanel.centerPanel = [[NavigationMovieCustomController alloc] initWithRootViewController:[AppDelegate share].mainController];
        [[AppDelegate share].mainPanel showCenterPanelAnimated:YES];
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Init cell
    static NSString *cellid=@"hello";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    if ([self tableView:tableView canCollapseSection:indexPath.section]) {
        
        NSString *stringValue = self.dictMenu.allValues[indexPath.section];
        if ([stringValue isEqualToString:kPhimLeString]) {
            cell.textLabel.text = kDicMainMenu.allValues[indexPath.row];
        } else if ([stringValue isEqualToString:kPhimBoString]) {
            cell.textLabel.text = kDicMainMenuPhimBo.allValues[indexPath.row];
        }
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tbvListMenu.frame.size.width-15, 1)];
        separatorLineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:separatorLineView];
        
    } else {
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.text= kEmptyString;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) { [tableView setSeparatorInset:UIEdgeInsetsZero]; }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) { [tableView setLayoutMargins:UIEdgeInsetsZero]; }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { [cell setLayoutMargins:UIEdgeInsetsZero]; }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger keyGenre = [self.dictMenu.allKeys[indexPath.section] integerValue];
    NSDictionary *dict = getDictTitleMenu(keyGenre);

    // Get list movie in local
    // Using GCD to get list db local
    [[DataAccess share] listMovieLocalByTag:dict.allKeys[indexPath.row]
                                   andGenre:stringFromInteger([MovieSearch share].genreMovie)
                                    andPage:kPageDefault completionBlock:^(BOOL success, NSMutableArray *array) {
                                        // Init film controler
                                        FilmController *filmController = [Utilities initFilmControllerWithTag:dict.allKeys[indexPath.row]
                                                                                                    numberTag:indexPath.row
                                                                                                    andListDb:array];
                                    
                                        [AppDelegate share].mainPanel.centerPanel = [[NavigationMovieCustomController alloc] initWithRootViewController:filmController];
                                        [[AppDelegate share].mainPanel showCenterPanelAnimated:YES];
                                        
                                        self.expandedIndexPath = nil;
                                        [self updateTableView];
                                    }];
}

- (void)updateTableView
{
    [UIView transitionWithView:self.tbvListMenu
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void)
     {
         [self.tbvListMenu reloadData];
     }
                    completion:nil];
}

- (void)resetExpandTableView {
    if (self.expandedIndexPath) {
        self.expandedIndexPath = nil;
        [self updateTableView];
        
    }
}

@end
