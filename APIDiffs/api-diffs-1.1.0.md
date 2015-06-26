# PLAudioStreamingKit 1.0.2 to 1.1.0 API Differences

## General Headers

```
PLStream.h
```

- *Added* Class `PLStream`

```
PLAudioStreamingKit.h
```

- *Added* Header `#import "PLStream.h"`

```
PLAudioStreamingSession.h
```

- *Added* Property `@property (nonatomic, PL_STRONG) PLStream   *stream;`
- *Added* Property `@property (nonatomic, PL_STRONG) NSString   *rtmpPublishHost;`
- *Added* Method `- (instancetype)initWithConfiguration:(PLAudioStreamingConfiguration *)configuration stream:(PLStream *)stream rtmpPublishHost:(NSString *)rtmpPublishHost;`
- *Added* Mehtod `- (void)startWithCompleted:(void (^)(BOOL success))handler;`
- *Added* Category `PLAudioStreamingSession (Deprecated)`
- *Deprecated* Method `- (void)startWithPushURL:(NSURL *)pushURL completed:(void (^)(BOOL success))handler`