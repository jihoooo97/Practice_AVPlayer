//
//  AudioPlayViewController.swift
//  Practice_AVPlayer
//
//  Created by 유지호 on 7/10/24.
//

import UIKit
import AVFoundation

final class AudioPlayViewController: BaseViewController {
    
    private lazy var slider = UISlider()
    private lazy var currentTimeLabel = UILabel()
    private lazy var totalTimeLabel = UILabel()
    private lazy var playButton = UIButton()
    
    private let player = AVPlayer()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlayer()
        addPeriodicTimeObserver()
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
    private func didChangeSlide(slider: UISlider, event: UIEvent) {
        guard let touchEvent = event.allTouches?.first else { return }
        let totalTime = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let currentTime = Float64(slider.value) * totalTime
        let time = CMTimeMakeWithSeconds(currentTime, preferredTimescale: Int32(NSEC_PER_SEC))
        
        switch touchEvent.phase {
        case .began:
            player.pause()
        case .moved:
            player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        case .ended:
            player.play()
        default: break
        }
    }
    
    private func setPlayer() {
        guard let url = MediaConstants.url(from: .soundHelix) else { return }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] currentSeconds in
            let currentTime = CMTimeGetSeconds(currentSeconds)
            let totalTime = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            
            guard !currentTime.isNaN || !currentTime.isInfinite,
                  !totalTime.isNaN || !totalTime.isInfinite
            else { return }
            
            let currentTimeSeconds = Int(currentTime)
            let totalTimeSeconds = Int(totalTime)
            
            self?.currentTimeLabel.text = String(format: "%02d:%02d", currentTimeSeconds.miniuteDigitInt, currentTimeSeconds.secondsDigitInt)
            self?.totalTimeLabel.text = String(format: "%02d:%02d", totalTimeSeconds.miniuteDigitInt, totalTimeSeconds.secondsDigitInt)
            self?.slider.value = Float(currentTime / totalTime)
        }
    }
    
    public override func setUIAttributes() {
        slider = {
            let slider = UISlider()
            slider.addTarget(self, action: #selector(didChangeSlide), for: .valueChanged)
            slider.translatesAutoresizingMaskIntoConstraints = false
            return slider
        }()
        
        currentTimeLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        totalTimeLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        playButton = {
            let button = UIButton(configuration: .borderedProminent())
            button.setTitle("재생", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(play), for: .touchUpInside)
            return button
        }()
    }
    
    public override func setLayout() {
        [slider, currentTimeLabel, totalTimeLabel, playButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 56),
            slider.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            slider.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),

            currentTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 8),
            currentTimeLabel.leftAnchor.constraint(equalTo: slider.leftAnchor),

            totalTimeLabel.topAnchor.constraint(equalTo: currentTimeLabel.topAnchor),
            totalTimeLabel.rightAnchor.constraint(equalTo: slider.rightAnchor),

            playButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
    }

}
