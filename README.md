![Swift 5.10](https://img.shields.io/badge/Swift-5.10-F05138.svg?style=flat&color=F05138) 
![Xcode 15.3](https://img.shields.io/badge/Xcode-15.3-147EFB.svg?style=flat&color=147EFB)
![iOS 17.0+](https://img.shields.io/badge/iOS-15.0+-147EFB.svg?style=flat&color=00E007)

# Practice_AVPlayer
iOS 환경에서 AVPlayer 사용해보기

<br>

## [📖](https://developer.apple.com/documentation/AVKit) AVKit
- 미디어 playback(재생, 녹음, 녹화)을 위한 interface를 제공하는 framework (전송 컨트롤, 챕터 탐색, PIP, 자막 제공)
- AVPlayerViewController, AVCaptureEventInteraction, AVCaptureEvent class 제공
- 커스텀을 원할 경우 AVPlayer 사용

<br>

## [📖](https://developer.apple.com/documentation/avfoundation) AVFoundation
- 시청각 미디어, 장치 카메라 제어, 오디오 처리, 시스템 오디오 상호 작용을 제공하는 framework
- UIKit 보단 Core(OS) 쪽에 가까운 framework

> ### [📖]() AVAsset
  - URL로 미디어를 객체화하는 class
  - AVAsset에 있는 미디어 데이터의 각 부분을 `track`이라고 정의 (video, audio, subtitle)
  - 메타데이터 보통 AVAsset은 데이터가 크므로, 비동기적으로 로드하여 AVAsset을 로드
  - AVAsset 인스턴스를 통해 미디어 데이터의 재생 가능 여부, 총 재생 시간, 생성 날짜, 메타 데이터 사용이 가능

> ### [📖](https://developer.apple.com/documentation/avfoundation/avplayer) AVPlayer
  - 플레이어의 전송 동작을 제어하는 interface 제공하는 객체
  - HTTP 실시간 스트리밍 파일을 재생할 때 사용(로컬에서 다운 받아 사용하는 경우는 AVAudioPlayer 사용)
  - AVPlayer → AVPlayerItem → AVAsset 순으로 의존성이 있음

    > #### [📖](https://developer.apple.com/documentation/avfoundation/avplayeritem) AVPlayerItem
    - 재생 중 미디어의 시간과 presentation state 정보를 갖고있는 객체
        - AVAsset: 정적인 상태 관리 (총 재생 시간, 생성 날짜)
        - AVPlayerItem: 동적인 상태 관리 (presentation state, 현재 시간, 현재까지 재생된 시간 등)
    - AVPlayer와 AVPlayerItem은 상태가 지속적으로 변하므로, 이 상태에 대한 값을 처리하기위해서 KVO를 통해 상태값을 구독하여 사용한다고 함

<br>

## 비디오 재생 방법
- AVPlayer와 AVPlayerItem은 비시각적인 객체이므로 화면에 영상 출력이 불가
    - AVKit을 통해 비디오 재생: 애플에서 미리 정의한 표준적인 비디오 재생 UI 제공 
    (iOS, tvOS: AVPlayerViewController / macOS: AVPlayerView)
    - AVPlayerLayer를 통해 비디오 재생: AVFoundation에서 제공. CALayer를 상속받은 AVPlayerLayer (오직 화면 출력 기능만을 제공하기 때문에 미디어 재생에 관한 기능은 모두 직접 구현)
- 보통 디자인 커스터마이징을 하기 때문에 AVKit보다는 AVPlayerLayer를 사용

ps. 부동소수점의 부정확성으로 인해 디테일한 시간의 작업이 필요한 미디어 재생에서의 문제점을 막기위해 [CMTime](https://developer.apple.com/documentation/coremedia/cmtime) 타입 사용
