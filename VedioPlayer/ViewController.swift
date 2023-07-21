//
//  ViewController.swift
//  VedioPlayer
//
//  Created by 黃瀞萱 on 2023/6/5.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    private var player: AVPlayer?
    private let origin = UIButton()
    private let custom = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        [origin, custom].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            origin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            origin.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            origin.heightAnchor.constraint(equalToConstant: 32),
            origin.widthAnchor.constraint(equalToConstant: 100),
            
            custom.topAnchor.constraint(equalTo: origin.bottomAnchor, constant: 30),
            custom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            custom.heightAnchor.constraint(equalToConstant: 32),
            custom.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        origin.setTitle("原生播放器", for: .normal)
        origin.backgroundColor = .lightGray
        origin.addTarget(self, action: #selector(tapOriginButton), for: .touchUpInside)
        
        custom.setTitle("客製播放器", for: .normal)
        custom.backgroundColor = .black
        custom.addTarget(self, action: #selector(navigateToCustom), for: .touchUpInside)
    }
    
    @objc
    private func tapOriginButton() {
        
        guard let url = URL(string: "https://ttt.a-p-i.io/out/cmafttt/210118L7.m3u8") else { return }
        
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.showsPlaybackControls = true
        playerViewController.showsTimecodes = true
        playerViewController.delegate = self
        
        present(playerViewController, animated: true) { [weak self] in
            self?.player?.play()
        }
    }
    
    @objc
    private func navigateToCustom() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CustomViewController") else { return }
        navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension ViewController: AVPlayerViewControllerDelegate { }

