//
//  InformationController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/24/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "InformationController.h"

@interface InformationController ()<FixAutolayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbPlot;
@property (weak, nonatomic) IBOutlet UILabel *lbCast;
@property (weak, nonatomic) IBOutlet UILabel *lbGenre;
@property (weak, nonatomic) IBOutlet UILabel *lbRuntime;
@property (weak, nonatomic) IBOutlet UILabel *lbReleaseDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csWidthPlot;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csWidthReleaseDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csWidthRuntime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csWidthTag;
@property (weak, nonatomic) IBOutlet CollectionMovie *collectionRelativeMovie;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csWidthCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lbIMDBRating;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csBottomConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingTrailer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lbNumberEpisode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csTopConstantDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csTopNumberEpi;
@property (strong, nonatomic) NSArray *listMovie;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleOfNumberEpi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csLeadingNumberEpi;
@end

@implementation InformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    [Utilities fixAutolayoutWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setInformationMovie];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Helper Method **

- (void)configView {
    [self.collectionRelativeMovie registerClass:[DetailMovieCell class] forCellWithReuseIdentifier:kDetailMovieCell];
    self.collectionRelativeMovie.dataSource = self;
    self.collectionRelativeMovie.delegate = self;
}

- (void)configLabel {
    [self.lbPlot sizeToFit];
    [self.lbCast sizeToFit];
    [self.lbGenre sizeToFit];
    [self.lbRuntime sizeToFit];
    [self.lbReleaseDate sizeToFit];
}

- (void)setInformationMovie {
    [self configLabel];
    self.lbPlot.text = self.movie.plotVI;
    self.lbCast.text = self.movie.cast;
    self.lbGenre.text = self.movie.category;
    self.lbRuntime.text = [NSString stringWithFormat:@"%d phút",(int)self.movie.runtime];
    self.lbIMDBRating.text = self.movie.imdbRating;
    self.lbReleaseDate.text = self.movie.releaseDate;
    
    if (self.movie.episode > 0) {
        self.lbNumberEpisode.text = [NSString stringWithFormat:@"Tập %d/%d",(int)self.movie.sequence,(int)self.movie.episode];
        self.lbNumberEpisode.hidden = NO;
        self.lbTitleOfNumberEpi.hidden = NO;
    } else {
        self.lbNumberEpisode.hidden = YES;
        self.lbTitleOfNumberEpi.hidden = YES;
    }
    
    
    self.listMovie = [[DataAccess share] getRelativeMovieInDB:self.movie.movieID];
    [self.collectionRelativeMovie reloadData];
    
    [self.scrollView setContentOffset:
     CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
}

- (IBAction)btnTrailer:(id)sender {
    if (![self.movie.trailer isEqualToString:kEmptyString]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.movie.trailer]];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark - ** Collection View Delegate **

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listMovie.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailMovieCell *cell = (DetailMovieCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionDetailMovieIdentifier forIndexPath:indexPath];
    cell.movie = self.listMovie[indexPath.row];
    cell.typeCell = kTypeFilm;
    [cell loadInformationWithMovie:self.listMovie[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayController *playController = nil;
    if (kPlayViewController) {
        playController = kPlayViewController;
        playController.movie = self.listMovie[indexPath.row];
        [playController getInformationMovie];
    } else {
        playController = InitStoryBoardWithIdentifier(kPlayController);
        playController.movie = self.listMovie[indexPath.row];
        [[AppDelegate share].mainController.navigationController pushViewController:playController animated:YES];
    }
}



//*****************************************************************************
#pragma mark -
#pragma mark - ** FixAutoLayoutDelegate **
- (void)fixAutolayoutFor35 {
    self.csWidthPlot.constant = [Utilities widthOfScreen] - kWidthConstantPlot;
    self.csWidthCollectionView.constant = [Utilities widthOfScreen] - kWidthConstantCollectionView;
    self.csWidthReleaseDate.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.csWidthTag.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.csWidthRuntime.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.leadingTrailer.constant = kLeadingTrailerConstant;
    self.csLeadingNumberEpi.constant = self.lbIMDBRating.frame.origin.x + self.lbIMDBRating.frame.size.width + self.leadingTrailer.constant;
    self.csTopNumberEpi.constant = self.csTopConstantDescription.constant;

}

- (void)fixAutolayoutFor40 {
    self.csWidthPlot.constant = [Utilities widthOfScreen] - kWidthConstantPlot;
    self.csWidthCollectionView.constant = [Utilities widthOfScreen] - kWidthConstantCollectionView;
    self.csWidthReleaseDate.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.csWidthTag.constant = [Utilities widthOfScreen] - 4.5*kWidthConstantPlot;
    self.csWidthRuntime.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.leadingTrailer.constant = kLeadingTrailerConstant;
    self.csLeadingNumberEpi.constant = self.lbIMDBRating.frame.origin.x + self.lbIMDBRating.frame.size.width + self.leadingTrailer.constant;
    self.csTopNumberEpi.constant = self.csTopConstantDescription.constant;
}

- (void)fixAutolayoutFor47 {
    self.csWidthPlot.constant = [Utilities widthOfScreen] - kWidthConstantPlot;
    self.csWidthCollectionView.constant = [Utilities widthOfScreen];
    self.csWidthReleaseDate.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.csWidthTag.constant = [Utilities widthOfScreen] -4.5*kWidthConstantPlot;
    self.csWidthRuntime.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.leadingTrailer.constant = kLeadingTrailerConstant;
    self.csLeadingNumberEpi.constant = self.lbIMDBRating.frame.origin.x + self.lbIMDBRating.frame.size.width + self.leadingTrailer.constant;
    self.csTopNumberEpi.constant = self.csTopConstantDescription.constant;
}

- (void)fixAutolayoutFor55 {
    self.csWidthPlot.constant = [Utilities widthOfScreen] - kWidthConstantPlot;
    self.csWidthCollectionView.constant = [Utilities widthOfScreen];
    self.csWidthReleaseDate.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.csWidthTag.constant = [Utilities widthOfScreen] - 4.5*kWidthConstantPlot;
    self.csWidthRuntime.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.csLeadingNumberEpi.constant = self.lbIMDBRating.frame.origin.x + self.lbIMDBRating.frame.size.width + self.leadingTrailer.constant;
    self.csTopNumberEpi.constant = self.csTopConstantDescription.constant;
}

-(void)fixAutolayoutForIpad {
    self.csWidthPlot.constant = [Utilities widthOfScreen] - kWidthConstantPlot;
    self.csWidthCollectionView.constant = [Utilities widthOfScreen];
    self.csWidthReleaseDate.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.csWidthTag.constant = [Utilities widthOfScreen] - 4.5*kWidthConstantPlot;
    self.csWidthRuntime.constant = [Utilities widthOfScreen] - 2*kWidthConstantPlot;
    self.csBottomConstant.constant += kBottomConstantIpad;
}

@end
