//
//  ViewController.swift
//  MyTimer
//
//  Created by 佐藤賢 on 2017/04/20.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var timer : Timer?
  var count = 0
  let settingKey = "timer_value"

  // 起動時に１回だけ呼び出される
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let settings = UserDefaults.standard
    settings.register(defaults: [settingKey:10])
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBOutlet weak var countDownLabel: UILabel!
  
  @IBAction func settingButtonAction(_ sender: Any) {
    if let nowTimer = timer {
      if nowTimer.isValid == true {
        nowTimer.invalidate()           // タイマー停止
      }
    }
    performSegue(withIdentifier: "goSetting", sender: nil)
  }
  
  @IBAction func startButtonAction(_ sender: Any) {
    if let nowTimer = timer {
      if nowTimer.isValid == true {     // もしタイマーが実行中ならば、スタートしない
        return                          // 何も処理しない
      }
    }
    // タイマーをスタート
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerInterrupt(_:)), userInfo: nil, repeats: true)
  }

  @IBAction func stopButtonAction(_ sender: Any) {
    if let nowTimer = timer {
      if nowTimer.isValid == true {
        nowTimer.invalidate()           // タイマー停止
      }
    }
  }
  
  func displayUpdate() -> Int {
    let settings = UserDefaults.standard
    let timerValue = settings.integer(forKey: settingKey)
    let remainCount = timerValue - count
    
    countDownLabel.text = "残り\(remainCount)秒"
    return remainCount
  }
  
  // 経過時間の処理
  func timerInterrupt(_ timer:Timer) {
    count += 1
    if displayUpdate() <= 0 {
      count = 0
      timer.invalidate() // タイマー停止
      
      // カスタマイズ編：ダイアログを作成
      let alertController = UIAlertController(title: "終了", message: "タイマー終了時間です", preferredStyle: .alert)
      // ダイアログに表示させるOKボタンを作成
      let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      // アクションを追加
      alertController.addAction(defaultAction)
      // ダイアログの表示
      present(alertController, animated: true, completion: nil)
      
    }
  }
  
  // 画面切り替えのタイミングで処理を行う
  override func viewDidAppear(_ animated: Bool) {
    count = 0
    _ = displayUpdate()
  }
  
}

