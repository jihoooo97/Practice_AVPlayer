//
//  ViewController.swift
//  Practice_AVPlayer
//
//  Created by 유지호 on 7/8/24.
//

import UIKit
import AVFoundation

public final class ViewController: BaseViewController {
    
    private lazy var playSlider = UISlider()
    private lazy var elapsedTimeLabel = UILabel()
    private lazy var totalTimeLabel = UILabel()
    private lazy var playButton = UIButton()
    
    private let player = AVPlayer()
    
    private var elapsedTimeSecondsFloat: Float64 = 0 {
        didSet {
            guard elapsedTimeSecondsFloat != oldValue else { return }
            let elapsedSecondsInt = Int(elapsedTimeSecondsFloat)
            let elapsedTimeText = String(format: "%02d:%02d", elapsedSecondsInt.miniuteDigitInt, elapsedSecondsInt.secondsDigitInt)
            elapsedTimeLabel.text = elapsedTimeText
            progressValue = elapsedTimeSecondsFloat / totalTimeSecondsFloat
        }
    }
    
    private var totalTimeSecondsFloat: Float64 = 0 {
        didSet {
            guard totalTimeSecondsFloat != oldValue else { return }
            let totalSecondsInt = Int(totalTimeSecondsFloat)
            let totalTimeText = String(format: "%02d:%02d", totalSecondsInt.miniuteDigitInt, totalSecondsInt.secondsDigitInt)
            totalTimeLabel.text = totalTimeText
        }
    }
    
    private var progressValue: Float64? {
        didSet { playSlider.value = Float(elapsedTimeSecondsFloat / totalTimeSecondsFloat) }
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
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
        elapsedTimeSecondsFloat = Float64(playSlider.value) * totalTimeSecondsFloat
        let time = CMTimeMakeWithSeconds(elapsedTimeSecondsFloat, preferredTimescale: Int32(NSEC_PER_SEC))
        
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
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] elapsedTime in
            let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedTime)
            let totalTimeSecondsFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            
            guard !elapsedTimeSecondsFloat.isNaN,
                  !elapsedTimeSecondsFloat.isInfinite,
                  !totalTimeSecondsFloat.isNaN,
                  !totalTimeSecondsFloat.isInfinite
            else { return }
            
            self?.elapsedTimeSecondsFloat = elapsedTimeSecondsFloat
            self?.totalTimeSecondsFloat = totalTimeSecondsFloat
        }
    }
    
    public override func setUIAttributes() {
        setPlayer()
        
        playSlider = {
            let slider = UISlider()
            slider.addTarget(self, action: #selector(didChangeSlide), for: .valueChanged)
            slider.translatesAutoresizingMaskIntoConstraints = false
            return slider
        }()
        
        elapsedTimeLabel = {
            let label = UILabel()
            label.text = "00:00"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        totalTimeLabel = {
            let label = UILabel()
            label.text = "00:00"
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
        [playSlider, elapsedTimeLabel, totalTimeLabel, playButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            playSlider.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 56),
            playSlider.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            playSlider.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            
            elapsedTimeLabel.topAnchor.constraint(equalTo: playSlider.bottomAnchor, constant: 8),
            elapsedTimeLabel.leftAnchor.constraint(equalTo: playSlider.leftAnchor),
            
            totalTimeLabel.topAnchor.constraint(equalTo: elapsedTimeLabel.topAnchor),
            totalTimeLabel.rightAnchor.constraint(equalTo: playSlider.rightAnchor),
            
            playButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
    }
    
}
