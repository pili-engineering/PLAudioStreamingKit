# PLAudioStreamingKit

PLAudioStreamingKit 是为 **pili 流媒体云服务** 流媒体云服务提供的一套音频直播流 SDK, 旨在解决 iOS 端快速、轻松实现 iOS 设备接入直播，便于 **pili 流媒体云服务** 的开发者专注于产品业务本身，而不必在技术细节上花费不必要的时间。

## 功能特性

- [x] 硬件编解码
- [x] 多码率可选
- [x] AAC 音频编码
- [x] HeaderDoc 文档支持
- [x] 内置生成安全的 RTMP 推流地址
- [x] ARM64 支持
- [x] 支持 RTMP 协议直播推流
- [x] 支持后台推流

## 内容摘要

- [快速开始](#快速开始)
	- [配置工程](#配置工程)
	- [示例代码](#示例代码)
- [后台推流](#后台推流)
- [编码参数](#编码参数)
- [文档支持](#文档支持)
- [系统要求](#系统要求)
- [版本历史](#版本历史)

## 快速开始

先来看看 PLAudioStreamingKit 接入的步骤

### 配置工程

- 配置你的 Podfile 文件，添加如下配置信息

```shell
pod 'PLAudioStreamingKit'
```

- 安装 CocoaPods 依赖

```shell
pod install
```

或

```shell
pod update
```

- Done! 运行你工程的 workspace

### 示例代码

在需要的地方添加

```Objective-C
#import <PLAudioStreamingKit/PLAudioStreamingKit.h>
```

```PLAudioStreamingSession``` 是核心类，你只需要关注并使用这个类就可以完成通过摄像头推流、预览的工作

推流前务必要先检查麦克风的授权，```StreamingSession``` 的创建需要 Stream 对象和 Publish host

```Objective-C
// Stream 对象，正常情况该对象是从自有的服务端请求拿到的
PLStream *stream = [PLStream streamWithJSON:@{@"id": @"STREAM_ID",
                                              @"title": @"STREAM_TITLE",
                                              @"hub": @"HUB_NAME",
                                              @"publishKey": @"PUBLISH_KEY",
                                              @"publishSecurity": @"dynamic", // or static
                                              @"disabled": @(NO)}];

// Publish host
NSString *publishHost = @"YOUR_RTMP_PUBLISH_HOST";

// 授权后执行
void (^permissionBlock)(void) = ^{
        PLAudioStreamingConfiguration *configuration = [PLAudioStreamingConfiguration defaultConfiguration];
        self.session = [[PLAudioStreamingSession alloc] initWithConfiguration:configuration
                                                                        stream:stream
                                                               rtmpPublishHost:publishHost];
        self.session.delegate = self;
};

void (^noPermissionBlock)(void) = ^{ // 处理未授权情况 };
    
// 检查麦克风是否有授权
PLAuthorizationStatus status = [PLAudioStreamingSession microphoneAuthorizationStatus];

if (PLAuthorizationStatusNotDetermined == status) {
    [PLAudioStreamingSession requestMicrophoneAccessWithCompletionHandler:^(BOOL granted) {
        granted ? permissionBlock() : noPermissionBlock();
    }];
} else if (PLAuthorizationStatusAuthorized == status) {
    permissionBlock();
} else {
	noPermissionBlock();
}
```

推流操作

```Objective-C
// 开始推流，无论 security policy 是 static 还是 dynamic，都无需再单独计算推流地址
[self.session startWithCompleted:^(BOOL success) {
	// 这里的代码在主线程运行，所以可以放心对 UI 控件做操作
	if (success) {
		// 连接成功后的处理
		// 成功后，在这里才可以读取 self.session.pushURL，start 失败和之前不能确保读取到正确的 URL
	} else {
    	// 连接失败后的处理
	}
}];

// 停止推流
[self.session stop];
```

## 后台推流

```PLAudioStreamingKit``` 提供了两种后台模式，分别为：

```Objective-C
typedef NS_ENUM(NSUInteger, PLAudioStreamingBackgroundMode) {
    PLAudioStreamingBackgroundModeAutoStop = 0,
    PLAudioStreamingBackgroundModeKeepAlive,
    PLAudioStreamingBackgroundModeDefault = PLAudioStreamingBackgroundModeAutoStop
};
```

如需 App 进入后台后仍然可以持续推流，只需要简单的配置即可。

```
// 将 PLAudioStreamingSession 实例的 backgroundMode 设置为 PLAudioStreamingBackgroundModeKeepAlive
self.session.backgroundMode = PLAudioStreamingBackgroundModeKeepAlive;
```
开启工程的 ```Background Modes``` 中的 ```Audio and AirPlay```

![BackgroundMode](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/Images/background-mode.png?raw=true)

现在当你的 App 正在推流时，进入后台或关闭屏幕后，推流都将继续。

你可以通过实现 ```delegate``` 的方法来获取即将开始后台推流任务和即将结束后台推流任务的回调

```Objective-C
- (void)audioStreamingSessionWillBeginBackgroundTask:(PLAudioStreamingSession *)session;
- (void)audioStreamingSession:(PLAudioStreamingSession *)session willEndBackgroundTask:(BOOL)isExpirationOccurred;
```

## 编码参数

初始化 ```PLAudioStreamingConfiguration``` 时，可以指定 Bitrate

```Objective-C
typedef NS_ENUM(NSUInteger, PLStreamingAudioBitRate) {
    PLStreamingAudioBitRate_64Kbps = 64 * 1024,
    PLStreamingAudioBitRate_96Kbps = 96 * 1024,
    PLStreamingAudioBitRate_128Kbps = 128 * 1024,
    PLStreamingAudioBitRate_Default = PLStreamingAudioBitRate_128Kbps
};
```

默认的 configuration 使用 128Kbps 码率。

当前版本采样率恒定为 48000

## 文档支持

PLAudioStreamingKit 通过 HeaderDoc 直接实现文档支持。
开发者无需单独查阅文档，直接通过 Xcode 就可以查看接口和类的相关信息，减少不必要的麻烦。

![Encode 推荐](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/Images/header-doc.png?raw=true)

## 系统要求

- iOS Target : >= iOS 7

## 版本历史

- 1.1.1 ([Release Notes](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/ReleaseNotes/release-notes-1.1.1.md)) && [API Diffs](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/APIDiffs/api-diffs-1.1.1.md))
    - 添加后台推流支持
    - 添加后台任务的回调
- 1.1.0 ([Release Notes](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/ReleaseNotes/release-notes-1.1.0.md)) && [API Diffs](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/APIDiffs/api-diffs-1.1.0.md))
	- 添加了 `PLStream` 类，支持 `Coding` 协议便于打包存储
	- 更新 `StreamingSession` 创建方法，借助传递 `PLStream` 对象再无需推流时等待服务端生成推流地址
- 1.0.2 ([Release Notes](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/ReleaseNotes/release-notes-1.0.2.md)) && [API Diffs](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/APIDiffs/api-diffs-1.0.2.md))
	- 更新 repo 地址
- 1.0.1 ([Release Notes](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/ReleaseNotes/release-notes-1.0.1.md)) && [API Diffs](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/APIDiffs/api-diffs-1.0.1.md))
	- 修复杂音问题 
- 1.0.0 ([Release Notes](https://github.com/pili-engineering/PLAudioStreamingKit/blob/master/ReleaseNotes/release-notes-1.0.0.md))
	- 发布 CocoaPods 版本