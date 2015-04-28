# PLAudioStreamingKit

PLAudioStreamingKit 是为 **pili 流媒体云服务** 流媒体云服务提供的一套音频直播流 SDK, 旨在解决 iOS 端快速、轻松实现 iOS 设备接入直播，便于 **pili 流媒体云服务** 的开发者专注于产品业务本身，而不必在技术细节上花费不必要的时间。

## 内容摘要

- [快速开始](#快速开始)
	- [配置工程](#配置工程)
	- [示例代码](#示例代码)
- [文档支持](#文档支持)
- [功能特性](#功能特性)
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

推流前务必要先检查麦克风的授权，并记得设置预览界面

```Objective-C
// 授权后执行
void (^permissionBlock)(void) = ^{
        PLCameraStreamingConfiguration *configuration = [PLCameraStreamingConfiguration defaultConfiguration];
        self.session = [[PLAudioStreamingSession alloc] initWithConfiguration:configuration];
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
// 开始推流，这里的推流地址应该是你自己的服务端通过 pili 流媒体云服务请求到的
[self.session startWithPushURL:[NSURL URLWithString:@"YOUR_RTMP_PUSH_URL_HERE"] completed:^(BOOL success) {
	// 这里的代码在主线程运行，所以可以放心对 UI 控件做操作
	if (success) {
		// 连接成功后的处理
	} else {
    	// 连接失败后的处理
	}
}];

// 停止推流
[self.session stop];
```

## 文档支持

PLAudioStreamingKit 通过 HeaderDoc 直接实现文档支持。
开发者无需单独查阅文档，直接通过 Xcode 就可以查看接口和类的相关信息，减少不必要的麻烦。

![Encode 推荐](https://github.com/pili-io/PLAudioStreamingKit/blob/master/header-doc.png?raw=true)

## 功能特性

- [x] 硬件编解码
- [x] 多码率可选
- [x] AAC 音频编码
- [x] HeaderDoc 文档支持

## 系统要求

- iOS Target : >= iOS 7

## 版本历史
- 1.1.3 ([Release Notes](https://github.com/pili-io/PLAudioStreamingKit/blob/master/ReleaseNotes/release-notes-1.0.0.md))
	- 发布 CocoaPods 版本