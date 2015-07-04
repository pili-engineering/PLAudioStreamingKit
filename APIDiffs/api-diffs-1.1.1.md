# PLAudioStreamingKit 1.1.0 to 1.1.1 API Differences

## General Headers

```
PLTypeDefines.h
```

- *Added* Type `PLAudioStreamingBackgroundMode`

```
PLAudioStreamingSession.h
```

- *Modified* Protocol `PLAudioStreamingSessionDelegate`
    - *Added* Method `- (void)audioStreamingSessionWillBeginBackgroundTask:(PLAudioStreamingSession *)session;`
    - *Added* Method `- (void)audioStreamingSession:(PLAudioStreamingSession *)session willEndBackgroundTask:(BOOL)isExpirationOccurred;`
- *Added* Property `@property (nonatomic, assign) PLAudioStreamingBackgroundMode    backgroundMode;`
