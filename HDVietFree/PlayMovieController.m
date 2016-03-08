//
//  PlayMovieController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 2/29/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "PlayMovieController.h"

@interface PlayMovieController ()
@property(strong, nonatomic) MPMoviePlayerController *mediaPlayerController;
@property(assign, nonatomic) NSInteger timePlay;
@property(assign, nonatomic) BOOL playbackDurationSet;
@end

@implementation PlayMovieController

+ (nonnull PlayMovieController *)share {
    static dispatch_once_t once;
    static PlayMovieController *share;
    dispatch_once(&once, ^{
        share = [[self alloc] init];
    });
    return share;
}
@synthesize mediaPlayerController, aMovie, channelTv;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mediaPlayerController = nil;
    self.playbackDurationSet = NO;
    self.timePlayMovie = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Play media controller
 */
- (void)playMovieWithController:(nonnull UIViewController *)controller {
    if (aMovie.urlLinkPlayMovie && aMovie.urlLinkSubtitleMovie) {
        ProgressBarShowLoading(kLoading);
        [self playLinkM3U8:aMovie.urlLinkPlayMovie andLinkSub:aMovie.urlLinkSubtitleMovie andController:controller];
        
    } else if (channelTv.linkPlayChannel.length > 0){
        [self playLinkM3U8:channelTv.linkPlayChannel andLinkSub:nil andController:controller];
    } else {
        [Utilities showiToastMessage:@"Phim này hiện chưa có link"];
    }
}

- (void)playLinkM3U8:(NSString *)linkPlay andLinkSub:(NSString *)linkSub andController:(nonnull UIViewController *)controller {
    
    NSURL *url = [[NSURL alloc] initWithString:linkPlay];
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    player.moviePlayer.shouldAutoplay = NO;
    [player.moviePlayer prepareToPlay];
    mediaPlayerController = player.moviePlayer;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player.moviePlayer];
    
    //Add Absorver
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player.moviePlayer];
    player.view.tag = kTagMPMoviePlayerController;
    player.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    player.moviePlayer.view.transform = CGAffineTransformConcat(player.moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    [player.moviePlayer.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    NSString *subString = [Utilities getDataSubFromUrl:linkSub];
    if (subString.length > 0) {
        [player.moviePlayer openWithSRTString:subString completion:^(BOOL finished) {
            // Activate subtitles
            [player.moviePlayer showSubtitles];
            
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error.description);
            
            [Utilities showiToastMessage:@"Phim này hiện chưa có sub việt"];
        }];
    }
    
    ProgressBarDismissLoading(kEmptyString);
    // Present video
    kMoviePlayer = player;
    player.moviePlayer.shouldAutoplay = YES;
    [controller presentMoviePlayerViewControllerAnimated:player];
    [player.moviePlayer play];
    player.moviePlayer.currentPlaybackTime = self.timePlayMovie;

}

- (void)writeTimePlayToLocal:(MPMoviePlayerController *)player isEnd:(BOOL)isEnd {
    if (!isEnd) {
        if (aMovie) {
            [Utilities writeContentToFile:[NSString stringWithFormat:@"%@_%d",aMovie.movieID,(int)self.epiNumber]
                               andContent:[player currentPlaybackTime]];
        }
    } else {
        if (aMovie) {
            [Utilities writeContentToFile:[NSString stringWithFormat:@"%@_%d",aMovie.movieID,(int)self.epiNumber]
                               andContent:0];
        }
    }
    
}

- (void)moviePlaybackDidFinish:(nonnull NSNotification*)aNotification{
    ProgressBarDismissLoading(kEmptyString);
    MPMoviePlayerController* player = (MPMoviePlayerController*)aNotification.object;
    NSError *error = [[aNotification userInfo] objectForKey:@"error"];
    if (error) {
        [Utilities showiToastMessage:kErrorPlayMovie];
    }
    
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonUserExited) {
        if ([getChildController isKindOfClass:[PlayController class]] ||
            [getChildController isKindOfClass:[EpisodeController class]] ) {
            [getChildController dismissMoviePlayerViewControllerAnimated];
            if (round([player currentPlaybackTime]) != round([player duration])) {
                [self writeTimePlayToLocal:player isEnd:NO];
            }
            
        } else {
            if (round([player currentPlaybackTime]) != round([player duration])) {
                [self writeTimePlayToLocal:player isEnd:NO];
            }
        }
        
        [self resetPlayerDurationVar];
    } else if (value == MPMovieFinishReasonPlaybackError) {
        [self resetPlayerDurationVar];
    } else if (value == MPMovieFinishReasonPlaybackEnded) {
        if (self.timePlay == round([player duration])) {
            [self writeTimePlayToLocal:player isEnd:YES];
            [self resetPlayerDurationVar];
        } else if (round([kMoviePlayer.moviePlayer currentPlaybackTime]) == round([kMoviePlayer.moviePlayer duration])){
            [self writeTimePlayToLocal:player isEnd:YES];
            [self resetPlayerDurationVar];
        }
    }
}
- (void)moviePlayerPlaybackStateChanged:(NSNotification*)notification{
    MPMoviePlayerController* player = (MPMoviePlayerController*)notification.object;
    
    switch ( player.playbackState ) {
        case MPMoviePlaybackStatePlaying:
            
            if(!self.playbackDurationSet){
                [mediaPlayerController setCurrentPlaybackTime:player.initialPlaybackTime];
                self.playbackDurationSet=YES;
            }
            break;
            
        case MPMoviePlaybackStateInterrupted: {
            self.timePlay = round([player currentPlaybackTime]);
            [self writeTimePlayToLocal:player isEnd:NO];
        }
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            self.timePlay = round([player currentPlaybackTime]);
            [self writeTimePlayToLocal:player isEnd:NO];
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            if (round([player currentPlaybackTime]) != 0) {
                self.timePlay = round([player currentPlaybackTime]);
                [self writeTimePlayToLocal:player isEnd:NO];
            }
            
            break;
            
        default:
            break;
    }
}

- (void)resetPlayerDurationVar{
    kMoviePlayer = nil;
    self.playbackDurationSet=NO;
}

- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if ([getChildController isKindOfClass:[PlayController class]] ||
        [getChildController isKindOfClass:[EpisodeController class]] ) {
        
        if([kMoviePlayer.moviePlayer loadState] != MPMovieLoadStateUnknown)
        {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerLoadStateDidChangeNotification
                                                          object:nil];
        }
    }
}


@end
