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
@synthesize mediaPlayerController, aMovie;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mediaPlayerController = nil;
    self.playbackDurationSet = NO;
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
        NSURL *url = [[NSURL alloc] initWithString:aMovie.urlLinkPlayMovie];
        MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        mediaPlayerController = player.moviePlayer;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerLoadStateDidChange:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
        
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
        NSString *subString = [Utilities getDataSubFromUrl:aMovie.urlLinkSubtitleMovie];
        [player.moviePlayer openWithSRTString:subString completion:^(BOOL finished) {
            // Activate subtitles
            [player.moviePlayer showSubtitles];
            
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error.description);
            
            [Utilities showiToastMessage:@"Phim này hiện chưa có sub việt"];
        }];
        
        // Present video
        kMoviePlayer = player;
        [controller presentMoviePlayerViewControllerAnimated:player];
        [player.moviePlayer prepareToPlay];
        [player.moviePlayer play];
        player.moviePlayer.currentPlaybackTime = self.timePlayMovie;
        
    } else {
        [Utilities showiToastMessage:@"Phim này hiện chưa có link"];
    }
    
}

- (void)moviePlaybackDidFinish:(nonnull NSNotification*)aNotification{
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
                [Utilities writeContentToFile:[NSString stringWithFormat:@"%@_%d",self.aMovie.movieID,(int)self.epiNumber]
                                   andContent:[player currentPlaybackTime]];
            }
            
        } else {
            if (round([player currentPlaybackTime]) != round([player duration])) {
                [Utilities writeContentToFile:[NSString stringWithFormat:@"%@_%d",self.aMovie.movieID,(int)self.epiNumber]
                                   andContent:[player currentPlaybackTime]];
            }
        }
        
        kMoviePlayer = nil;
        [self resetPlayerDurationVar];
    } else if (value == MPMovieFinishReasonPlaybackError) {
        kMoviePlayer = nil;
        [self resetPlayerDurationVar];
    } else if (value == MPMovieFinishReasonPlaybackEnded) {
        if (self.timePlay == round([player duration])) {
            [Utilities writeContentToFile:[NSString stringWithFormat:@"%@_%d",self.aMovie.movieID,(int)self.epiNumber]
                               andContent:0];
            kMoviePlayer = nil;
            [self resetPlayerDurationVar];
        } else if (round([kMoviePlayer.moviePlayer currentPlaybackTime]) == round([kMoviePlayer.moviePlayer duration])){
            [Utilities writeContentToFile:[NSString stringWithFormat:@"%@_%d",self.aMovie.movieID,(int)self.epiNumber]
                               andContent:0];
            kMoviePlayer = nil;
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
            [Utilities writeContentToFile:[NSString stringWithFormat:@"%@_%d",self.aMovie.movieID,(int)self.epiNumber]
                               andContent:[player currentPlaybackTime]];
        }
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            self.timePlay = round([player currentPlaybackTime]);
            [Utilities writeContentToFile:[NSString stringWithFormat:@"%@_%d",self.aMovie.movieID,(int)self.epiNumber]
                               andContent:[player currentPlaybackTime]];
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            if (round([player currentPlaybackTime]) != 0) {
                self.timePlay = round([player currentPlaybackTime]);
                [Utilities writeContentToFile:[NSString stringWithFormat:@"%@_%d",self.aMovie.movieID,(int)self.epiNumber]
                                   andContent:[player currentPlaybackTime]];
            }
            
            break;
            
        default:
            break;
    }
}

- (void)resetPlayerDurationVar{
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
