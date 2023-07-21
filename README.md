# VideoPlayer

**關於 video 要在背景播放的方式**  
除了設定 NotificationCenter 之外，還是需要在 AppDelegate 設定 AVAudioSession
```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        return true
    }
```
