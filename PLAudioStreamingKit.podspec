#
# Be sure to run `pod lib lint PLAudioStreamingKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PLAudioStreamingKit"
  s.version          = "1.1.0"
  s.summary          = "Pili iOS AAC Audio streaming framework via RTMP."
  s.homepage         = "https://github.com/pili-engineering/PLAudioStreamingKit"
  s.license          = 'Apache License, Version 2.0'
  s.author           = { "0dayZh" => "0day.zh@gmail.com" }
  s.source           = { :git => "https://github.com/pili-engineering/PLAudioStreamingKit.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.public_header_files = 'Pod/Library/include/**/*.h'
  s.source_files = 'Pod/Library/include/**/*.h'

  s.frameworks = ['UIKit', 'AVFoundation', 'AudioToolbox', 'CoreAudio']
  s.libraries = 'z'

  s.default_subspec = "precompiled"

  s.subspec "precompiled" do |ss|
    ss.preserve_paths         = "Pod/Library/include/**/*.h", 'Pod/Library/lib/*.a'
    ss.vendored_libraries   = 'Pod/Library/lib/*.a'
    ss.libraries = 'PLAudioStreamingKit'
    ss.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/PLAudioStreamingKit/lib/include" }
  end
end
