//
//  ViewController.swift
//  LightSaber
//
//  Created by Ogawa Daichi on 2018/08/05.
//  Copyright © 2018年 Ogawa Daichi. All rights reserved.
//

// importするファイルはクラスの集合体
import UIKit
// 加速度センサーの値を取得
import CoreMotion
// 音の再生
import AVFoundation

class ViewController: UIViewController {
    
    let motionManager: CMMotionManager = CMMotionManager()
    var audioPlayer :AVAudioPlayer = AVAudioPlayer()
    var startAudioPlayer :AVAudioPlayer = AVAudioPlayer()
    var startAccel: Bool = false
    var buttonTappedTime: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
       setupSound()
    }

    @IBAction func tappedStartButton(_ sender: UIButton) {
        startAudioPlayer.play()
        buttonTappedTime += 1
        if buttonTappedTime % 2 == 1 {
            startGetAccelerometer()
        } else {
            return
        }
    }
    
    func setupSound() {
        if let sound = Bundle.main.path(forResource: "light_saber1", ofType: "mp3") {
            startAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            startAudioPlayer.prepareToPlay()
        }
        
        if let sound = Bundle.main.path(forResource: "light_saber3", ofType: "mp3") {
            audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            audioPlayer.prepareToPlay()
        }
    }
    
    func startGetAccelerometer() {
        motionManager.accelerometerUpdateInterval = 1 / 100
        
        // メーターが壊れている可能性、またerrorがない場合にその値としてnilを許容するか否かで？
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (accelerometerData: CMAccelerometerData?, error: Error?) in
            
            if let acc = accelerometerData {
                let x = acc.acceleration.x
                let y = acc.acceleration.y
                let z = acc.acceleration.z
                let synthetic = (x * x) + (y * y) + (z * z)
                
                if synthetic >= 8 && self.startAccel == false {
                    
                    self.startAccel = true
                    
                    self.audioPlayer.currentTime = 0
                    self.audioPlayer.play()
                }
                
                if synthetic < 1 && self.startAccel == true {
                    self.startAccel = false
                }
            }
        }
    }
}

