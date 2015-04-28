//
//  PLAudioStreamingConfiguration.h
//  PLAudioStreamingKit
//
//  Created on 15/4/28.
//  Copyright (c) 2015年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PLTypeDefines.h"
#import "PLMacroDefines.h"

@interface PLAudioStreamingConfiguration : NSObject

@property (nonatomic, assign, readonly) PLStreamingAudioBitRate audioBitRate;
@property (nonatomic, assign, readonly) NSUInteger audioSampleRate; // always 48000

+ (instancetype)defaultConfiguration;
+ (instancetype)configurationWithAudioBitRate:(PLStreamingAudioBitRate)audioBitRate;

@end
