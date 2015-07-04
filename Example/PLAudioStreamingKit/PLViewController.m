//
//  PLViewController.m
//  PLAudioStreamingKit
//
//  Created by 0dayZh on 04/28/2015.
//  Copyright (c) 2014 0dayZh. All rights reserved.
//

#import "PLViewController.h"
#import <PLAudioStreamingKit/PLAudioStreamingKit.h>

const char *stateNames[] = {
    "Unknow",
    "Connecting",
    "Connected",
    "Disconnected",
    "Error"
};

@interface PLViewController ()
<
PLAudioStreamingSessionDelegate
>

@property (nonatomic, strong) PLAudioStreamingSession  *session;

@end

@implementation PLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning 仅为测试，发布的 App 中需要请求自有服务端获取 Stream
    PLStream *stream = [PLStream streamWithJSON:@{@"id": @"STREAM_ID",
                                                  @"title": @"STREAM_TITLE",
                                                  @"hub": @"HUB_NAME",
                                                  @"publishKey": @"PUBLISH_KEY",
                                                  @"publishSecurity": @"dynamic",   // or static
                                                  @"disabled": @(NO)}];
    NSString *publishHost = @"YOUR_PUBLISH_HOST";
    
    void (^permissionBlock)(void) = ^{
        PLAudioStreamingConfiguration *configuration = nil;
        
        // 默认配置
        configuration = [PLAudioStreamingConfiguration defaultConfiguration];
        
        self.session = [[PLAudioStreamingSession alloc] initWithConfiguration:configuration
                                                                       stream:stream
                                                              rtmpPublishHost:publishHost];
        self.session.delegate = self;
        
        // 支持后台推流
        self.session.backgroundMode = PLAudioStreamingBackgroundModeKeepAlive;
    };
    
    void (^noAccessBlock)(void) = ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Access", nil)
                                                            message:NSLocalizedString(@"!", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    };
    
    switch ([PLAudioStreamingSession microphoneAuthorizationStatus]) {
        case PLAuthorizationStatusAuthorized:
            permissionBlock();
            break;
        case PLAuthorizationStatusNotDetermined: {
            [PLAudioStreamingSession requestMicrophoneAccessWithCompletionHandler:^(BOOL granted) {
                granted ? permissionBlock() : noAccessBlock();
            }];
        }
            break;
        default:
            noAccessBlock();
            break;
    }
}

#pragma mark - <PLAudioStreamingSessionDelegate>

- (void)audioStreamingSession:(PLAudioStreamingSession *)session streamStateDidChange:(PLStreamState)state {
    NSLog(@"Stream State: %s", stateNames[state]);
    
    if (PLStreamStateConnected == state) {
        [self.actionButton setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
    } else {
        [self.actionButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    }
}

- (void)audioStreamingSessionWillBeginBackgroundTask:(PLAudioStreamingSession *)session {
    NSLog(@"Background Task Will Begin.");
}

- (void)audioStreamingSession:(PLAudioStreamingSession *)session willEndBackgroundTask:(BOOL)isExpirationOccurred {
    NSLog(@"Background Task Will End.");
    if (isExpirationOccurred) {
        // 因为 App 在后台时间超过了苹果给予的时间，此时你可以从产品层面考虑做一些操作，比如提醒直播者重新打开 App 以便继续推流
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = NSLocalizedString(@"Your live will be stopped", nil);
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

#pragma mark - Action

- (IBAction)actionButtonPressed:(id)sender {
    if (PLStreamStateConnected == self.session.streamState) {
        [self.session stop];
    } else {
        self.actionButton.enabled = NO;
        [self.session startWithCompleted:^(BOOL success) {
            if (success) {
                NSLog(@"Publish URL: %@", self.session.pushURL.absoluteString);
            }
            
            self.actionButton.enabled = YES;
        }];
    }
}

- (IBAction)muteButtonPressed:(id)sender {
    self.session.muted = !self.session.isMuted;
}

@end
