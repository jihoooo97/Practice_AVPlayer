//
//  ViewController.swift
//  Practice_AVPlayer
//
//  Created by 유지호 on 7/8/24.
//

import UIKit

public final class ViewController: BaseViewController {
    
    private let audioButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.setTitle("Audio", for: .normal)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let videoButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.setTitle("Video", for: .normal)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        audioButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    
    @objc
    private func didTapButton(_ button: UIButton, _ event: UITouch) {
        if button.tag == 0 {
            self.navigationController?.pushViewController(AudioPlayViewController(), animated: true)
        } else {
            self.navigationController?.pushViewController(VideoPlayViewController(), animated: true)
        }
    }
    
    public override func setLayout() {
        view.addSubview(audioButton)
        view.addSubview(videoButton)
        
        NSLayoutConstraint.activate([
            audioButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            audioButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            videoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            videoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
}
