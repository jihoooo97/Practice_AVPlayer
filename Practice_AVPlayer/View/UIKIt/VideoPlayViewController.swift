//
//  VideoPlayViewController.swift
//  Practice_AVPlayer
//
//  Created by 유지호 on 7/10/24.
//

import UIKit
import AVFoundation

final class VideoPlayViewController: BaseViewController {
    
    private lazy var videoContainer = UIView()
    private lazy var slider = UISlider()
    private lazy var playButton = UIButton()
    
    private let urlString = "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8"
    private let player = AVPlayer()
    private let playerLayer = AVPlayerLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlayer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        playerLayer.frame = videoContainer.bounds
    }
    
    
    private func setPlayer() {
        guard let url = URL(string: urlString) else { return }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        
        playerLayer.player = player
        playerLayer.frame = videoContainer.bounds
        playerLayer.videoGravity = .resizeAspectFill
        
        videoContainer.layer.addSublayer(playerLayer)
        
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
    }

    override func setLayout() {
        [videoContainer, slider, playButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            videoContainer.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 70),
            videoContainer.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -70),
            videoContainer.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -250),
            videoContainer.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 200),

            slider.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 16),
            slider.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            slider.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            
            playButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 16),
        ])
    }
    
}
