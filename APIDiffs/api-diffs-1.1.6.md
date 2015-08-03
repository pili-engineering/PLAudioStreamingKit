# PLAudioStreamingKit 1.1.5 to 1.1.6 API Differences

## General Headers

```PLStream.h```

- *Modified* Class `PLStream`

```PLAudioStreamingSession.h```

- *Deprecated* Method `- (instancetype)initWithConfiguration:(PLAudioStreamingConfiguration *)configuration stream:(PLStream *)stream rtmpPublishHost:(NSString *)rtmpPublishHost`
- *Added* Method `- (instancetype)initWithConfiguration:(PLAudioStreamingConfiguration *)configuration
                               stream:(PLStream *)stream`