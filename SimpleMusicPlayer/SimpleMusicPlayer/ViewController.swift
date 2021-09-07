//
//  ViewController.swift
//  SimpleMusicPlayer
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    // MARK:- Properties
    var player: AVAudioPlayer!
    var timer: Timer!
    
    // MARK: IBOutlets
    @ IBOutlet weak var playPauseButton: UIButton!
    @ IBOutlet weak var timeLabel: UILabel!
    @ IBOutlet weak var timeSlider: UISlider!
    
    // MARK:- Methods
    // MARK: Custom Method
    // 플레이어 초기화 메소드
    func initPlayer(){
        
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else {
            print("음악 파일을 가져올 수 없습니다.")
            return
        }
        
        do{
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError{
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
        
        self.timeSlider.maximumValue = Float(self.player.duration)
        self.timeSlider.minimumValue = 0
        self.timeSlider.value = Float(self.player.currentTime)
    }
    
    // timeLabel 업데이트 메소드
    func updateTimeLabelText(time: TimeInterval){
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        self.timeLabel.text = timeText
    }
    
    // timer 생성 및 수행 메소드
    func makeAndFireTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {[unowned self] (timer: Timer) in
            
            if self.timeSlider.isTracking{ return }
            
            self.updateTimeLabelText(time: self.player.currentTime)
            self.timeSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    
    // timer 해제 메소드
    func invalidateTimer(){
        self.timer.invalidate()
        self.timer = nil
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initPlayer()
    }
    
    // MARK: IBActions
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            self.player?.play()
        } else{
            self.player?.pause()
        }
        
        if sender.isSelected{
            self.makeAndFireTimer()
        } else{
            self.invalidateTimer()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider){
        
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking{ return }
        self.player.currentTime = TimeInterval(sender.value)
    }
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        guard let error: Error = error else {
            print("플레이어 오류")
            return
        }
        
        let message: String
        message = "플레이어 오류 \(error.localizedDescription)"
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){
            (action: UIAlertAction) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.isSelected = false
        self.timeSlider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
}
