//
//  MainController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/25/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "MainController.h"

@interface MainController ()<UICollectionViewDataSource, UICollectionViewDelegate>

// Property
@property (strong, nonatomic) NSDictionary *dictMenu;

// IBOutlet
@property (weak, nonatomic) IBOutlet UICollectionView *collectionTopMenu;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionDetailMovie;

@end

@implementation MainController

//*****************************************************************************
#pragma mark -
#pragma mark - ** Life Cycle **

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
    // Hidden navigation bar
    [self.navigationController.navigationBar setHidden:NO];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **
- (void)configView {
    self.dictMenu = kDicMainMenu;
    
    // Register custom cell
    [self.collectionDetailMovie registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:@"DetailMovieCell"];
    [self.collectionTopMenu registerClass:[TopMenuCell class] forCellWithReuseIdentifier:@"TopMenuCell"];
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Collection View Delegate **

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (collectionView.tag) {
        case kTagCollectionDetailMovie:
            return 10;
            break;
            
        default:
            return self.dictMenu.count;
            break;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (collectionView.tag) {
            // Detail movie
        case kTagCollectionDetailMovie: {
            DetailMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionDetailMovieIdentifier forIndexPath:indexPath];
            return cell;
        }
            break;
            
            // Top menu
        default: {
            TopMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionTopMenuIdentifier forIndexPath:indexPath];
            cell.lbName.text = self.dictMenu.allValues[indexPath.row];
            return cell;
        }
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
