//
//  PlayController.m
//  HDVietFree
//
//  Created by Bao (Brian) L. LE on 1/22/16.
//  Copyright © 2016 Brian. All rights reserved.
//

#import "PlayController.h"
@import MediaPlayer;

@interface PlayController ()<MPMediaPickerControllerDelegate,MPMediaPlayback>

@end

@implementation PlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self playMediaController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)playMediaController {
    NSURL *url = [[NSURL alloc] initWithString:@"http://plist.vn-hd.com/mp4childv3/2982963905c77744565d051df2822fe9/947842ab03c548e7be5999157d22563d/6614d5f054e811e58d2e44d3cad9dd84/3784_800_ivdc.m3u8"];
    MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    
    [self presentMoviePlayerViewControllerAnimated:mpvc];
    [mpvc.moviePlayer play];
}

-(void)moviePlaybackDidFinish:(NSNotification*)aNotification{
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonUserExited) {
        [self dismissMoviePlayerViewControllerAnimated];
    }
}

@end
