//
//  PLTypeDefines.h
//  PLAudioStreamingKit
//
//  Created on 15/3/26.
//  Copyright (c) 2015年 Pili Engineering. All rights reserved.
//

#ifndef PLAudioStreamingKit_PLTypeDefines_h
#define PLAudioStreamingKit_PLTypeDefines_h

typedef NS_ENUM(NSUInteger, PLAuthorizationStatus) {
    PLAuthorizationStatusNotDetermined = 0,
    PLAuthorizationStatusRestricted,
    PLAuthorizationStatusDenied,
    PLAuthorizationStatusAuthorized
};

typedef NS_ENUM(NSUInteger, PLStreamState) {
    PLStreamStateUnknow = 0,
    PLStreamStateConnecting,
    PLStreamStateConnected,
    PLStreamStateDisconnected,
    PLStreamStateError
};

typedef NS_ENUM(NSUInteger, PLStreamingAudioBitRate) {
    PLStreamingAudioBitRate_64Kbps = 64 * 1024,
    PLStreamingAudioBitRate_96Kbps = 96 * 1024,
    PLStreamingAudioBitRate_128Kbps = 128 * 1024,
    PLStreamingAudioBitRate_Default = PLStreamingAudioBitRate_128Kbps
};

typedef NS_ENUM(NSUInteger, PLAudioStreamingBackgroundMode) {
    PLAudioStreamingBackgroundModeAutoStop = 0,
    PLAudioStreamingBackgroundModeKeepAlive,
    PLAudioStreamingBackgroundModeDefault = PLAudioStreamingBackgroundModeAutoStop
};

typedef NS_ENUM(NSUInteger, PLStreamingNetworkType) {
    PLStreamingNetworkTypeCELL,
    PLStreamingNetworkTypeWiFi,
    PLStreamingNetworkTypeEither
} DEPRECATED_ATTRIBUTE;

#endif
