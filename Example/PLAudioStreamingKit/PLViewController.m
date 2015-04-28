//
//  PLViewController.m
//  PLAudioStreamingKit
//
//  Created by 0dayZh on 04/28/2015.
//  Copyright (c) 2014 0dayZh. All rights reserved.
//

#import "PLViewController.h"
#import <PLAudioStreamingKit/PLAudioStreamingKit.h>

#warning 这里替换为你的推流地址
#define PUSH_URL    @"YOUR_PUSH_URL_HERE"

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
    
    void (^permissionBlock)(void) = ^{
        PLAudioStreamingConfiguration *configuration = nil;
        
        // 默认配置
        configuration = [PLAudioStreamingConfiguration defaultConfiguration];
        
        self.session = [[PLAudioStreamingSession alloc] initWithConfiguration:configuration];
        self.session.delegate = self;
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

#pragma mark - Action

- (IBAction)actionButtonPressed:(id)sender {
    if (PLStreamStateConnected == self.session.streamState) {
        [self.session stop];
    } else {
        self.actionButton.enabled = NO;
        [self.session startWithPushURL:[NSURL URLWithString:PUSH_URL] completed:^(BOOL success) {
            self.actionButton.enabled = YES;
        }];
    }
}

- (IBAction)muteButtonPressed:(id)sender {
    self.session.muted = !self.session.isMuted;
}

@end
