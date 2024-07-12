//
//  VideoPlayViewController.swift
//  Practice_AVPlayer
//
//  Created by 유지호 on 7/10/24.
//

import UIKit
import AVKit

final class VideoPlayViewController: BaseViewController {
    
    private var pipController: AVPictureInPictureController?
    
    private lazy var videoContainer = UIView()
    private lazy var slider = UISlider()
    private lazy var playButton = UIButton()
    private lazy var pipButton = UIButton()
    
    private let urlString = "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8"
    private let player = AVPlayer()
    private let playerLayer = AVPlayerLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setPlayer()
        setPIP()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = videoContainer.bounds
    }
    
    
    private func setPlayer() {
        guard let url = URL(string: urlString) else { return }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] currentSeconds in
            let currentTime = CMTimeGetSeconds(currentSeconds)
            let totalTime = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            
            guard !currentTime.isNaN && !currentTime.isInfinite,
                  !totalTime.isNaN && !totalTime.isInfinite
            else { return }
            
            self?.slider.value = Float(currentTime / totalTime)
        }
    }
    
    private func setPIP() {
        guard let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else { return }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
        
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] currentSeconds in
            let currentTime = CMTimeGetSeconds(currentSeconds)
            let totalTime = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            
            guard !currentTime.isNaN && !currentTime.isInfinite,
                  !totalTime.isNaN && !totalTime.isInfinite
            else { return }
            
            self?.slider.value = Float(currentTime / totalTime)
        }
        
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            pipButton.isEnabled = false
            return
        }
        
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.delegate = self
    }
    
    @objc
    private func play() {
        switch player.timeControlStatus {
        case .paused:
            player.play()
            playButton.setTitle("일시정지", for: .normal)
        case .playing:
            player.pause()
            playButton.setTitle("재생", for: .normal)
        default: break
        }
    }
    
    @objc
    private func pip() {
        guard let isActive = pipController?.isPictureInPictureActive else { return }
        
        if isActive {
            pipController?.stopPictureInPicture()
            pipButton.setTitle("PIP 활성화", for: .normal)
        } else {
            pipController?.startPictureInPicture()
            pipButton.setTitle("PIP 비활성화", for: .normal)
        }
    }
    
    @objc
    private func changeValue() {
        let totalTime = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let elapsedTime = Float64(slider.value) * totalTime
        let time = CMTimeMakeWithSeconds(elapsedTime, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    override func setUIAttributes() {
        videoContainer = {
            let view = UIView()
            view.backgroundColor = .systemGray
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        slider = {
            let slider = UISlider()
            slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
            slider.translatesAutoresizingMaskIntoConstraints = false
            return slider
        }()
        
        playButton = {
            let button = UIButton(configuration: .borderedProminent())
            button.setTitle("재생", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(play), for: .touchUpInside)
            return button
        }()
        
        pipButton = {
            let button = UIButton(configuration: .borderedProminent())
            button.setTitle("PIP 활성화", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(pip), for: .touchUpInside)
            return button
        }()
        
        videoContainer.layer.addSublayer(playerLayer)
    }

    override func setLayout() {
        [videoContainer, slider, playButton, pipButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            videoContainer.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            videoContainer.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            videoContainer.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -250),
            videoContainer.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 200),

            slider.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 16),
            slider.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            slider.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            
            playButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 16),
            
            pipButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            pipButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 16),
        ])
    }
    
}


extension VideoPlayViewController: AVPictureInPictureControllerDelegate {
    
    // MARK: PIP 버튼 눌렀을 때
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("willStart")
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("didStart")
    }
    
    // MARK: PIP 중지할 때
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("willStop")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("didStop")
    }
    
    // MARK: 작아진 PIP 화면을 다시 키울 때
    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
    ) {
        print("restore")
        completionHandler(true)
    }
    
    // MARK: 기타 에러
    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        failedToStartPictureInPictureWithError error: Error
    ) {
        print(error.localizedDescription)
    }
    
}
