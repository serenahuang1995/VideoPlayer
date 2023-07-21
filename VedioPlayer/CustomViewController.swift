//
//  CustomViewController.swift
//  VedioPlayer
//
//  Created by 黃瀞萱 on 2023/6/13.
//

import UIKit
import AVFoundation

class CustomViewController: UIViewController {
    
    // UI prperties
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var subtitleSwitch: UISwitch!
    
    // player properties
    private var player: AVPlayer?
    private var item: AVPlayerItem!
    private var layer: AVPlayerLayer!
    private let mediaURL = URL(string: "https://ttt.a-p-i.io/out/cmafttt/210118L7.m3u8")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupSlider()
    }
    
    @IBAction func changePlayStatus(_ sender: UIButton) {
        switch player?.timeControlStatus {
        case .playing:
            player?.pause()
            playButton.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
        case .paused, .waitingToPlayAtSpecifiedRate:
            player?.play()
            playButton.setImage(UIImage.init(systemName: "pause.fill"), for: .normal)
        default:break
        }
    }
    
    @IBAction func goBackward(_ sender: Any) {
        guard let player = player else { return }
        let target = CMTime(seconds: player.currentTime().seconds - 15, preferredTimescale: 1)
        player.seek(to: target)
    }

    @IBAction func goForward(_ sender: Any) {
        guard let player = player else { return }
        let target = CMTime(seconds: player.currentTime().seconds + 15, preferredTimescale: 1)
        player.seek(to: target)
    }
    
    @IBAction func switchSubtitles(_ sender: UISwitch) {
        guard let playerItem = player?.currentItem,
              let group = playerItem.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else {
            return
        }
        
        if sender.isOn {
            // 將字幕軌道加進去
            playerItem.select(group.defaultOption, in: group)
        } else {
            // 選擇 nil 來取消選擇字幕軌道，從而移除字幕
            playerItem.select(nil, in: group)

        }
    }
    
    
    // 全螢幕旋轉 -> 有成功，但 size 怪怪的
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//        coordinator.animate(alongsideTransition: { _ in
//            // 更新 videoView 的佈局
//            self.updateVideoViewLayout(size: size)
//        }, completion: nil)
//    }
//
//    func updateVideoViewLayout(size: CGSize) {
//        // 計算新的 videoView 的大小
//        let videoViewSize = calculateVideoViewSize(size: size)
//
//        // 更新 videoView 的佈局約束或 frame
//        // 例如，使用 Auto Layout 更新佈局約束
//        verticalStackView.constraints.forEach { constraint in
//            if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
//                constraint.constant = videoViewSize.width
//            }
//        }
//
//        // 或者，如果你不使用 Auto Layout，你可以直接設定 videoView 的 frame
//        verticalStackView.frame = CGRect(x: 0, y: 0, width: videoViewSize.width, height: videoViewSize.height)
//    }
//
//    func calculateVideoViewSize(size: CGSize) -> CGSize {
//        // 根據新的螢幕尺寸計算 videoView 的大小
//        // 你可以根據需求進行計算，例如根據新的寬高比例計算、固定比例縮放等等
//        let width = size.width // 設定為螢幕的寬度
//        let height = width * 9 / 16 // 假設為 16:9 的寬高比例
//        return CGSize(width: width, height: height)
//    }
    
}

//MARK: - Slider setup
extension CustomViewController {
    
    private func setupSlider() {
        slider.minimumValue = 0
        slider.maximumValue = Float(item.asset.duration.seconds)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let time = CMTime(seconds: Double(sender.value), preferredTimescale: 1)
        player?.seek(to: time)
    }
    
    private func updateSliderValue(_ time: CMTime) {
        let currentTime = time.seconds
        slider.value = Float(currentTime)
    }
}

//MARK: - Player setup
extension CustomViewController {
    
    private func setupPlayer() {
        // 建立AVPlayer
        item = AVPlayerItem(url: mediaURL!)
        player = AVPlayer(playerItem: item)

        // 字幕，default 是有字幕（因為目前字幕是直接放進 m3u8 url 裡面）
        if let playerItem = player?.currentItem, let group = playerItem.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) {
            playerItem.select(group.defaultOption, in: group)
        }
        
        // 將 AVPlayerLayer 放到 view 上
        layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspect
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: baseView.bounds.height)
        baseView.layer.addSublayer(layer)

        // notifiy slider
        player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak self] time in
            self?.updateSliderValue(time)
        }
        
        // 背景播放
        // AppDelegate 還是要設定 AVAudioSession
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }

    @objc func enterBackground() {
        layer.player = nil
    }

    @objc func enterForeground() {
        layer.player = player
    }
}
