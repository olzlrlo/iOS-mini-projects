//
//  ViewController.swift
//  UpDownGame
//

import UIKit

class ViewController: UIViewController {
    
    var randomValue : Int = 0
    var tryCount : Int = 0
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var tryCountLabel : UILabel!
    @IBOutlet weak var sliderValueLabel : UILabel!
    @IBOutlet weak var minimumValueLabel : UILabel!
    @IBOutlet weak var maximumValueLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        slider.setThumbImage(#imageLiteral(resourceName: "slider_thumb"), for: .normal)
        reset()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider){
        print(sender.value)
        let integerValue : Int = Int(sender.value) // Int로 slider 값 저장
        sliderValueLabel.text = String(integerValue) // String으로 변환
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.reset()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func touchUpHitButton(_ sender: UIButton){
        print(slider.value)
        let hitValue : Int = Int(slider.value) // 값 저장 (22.5 -> 22)
        slider.value = Float(hitValue) // slider 이동 (22.5 -> 22.0)
    
        tryCount += 1
        tryCountLabel.text = String(tryCount) + " / 5"
        
        if randomValue == hitValue {
            showAlert(message: "You HIT >_<")
            reset()
        } else if tryCount >= 5 {
            showAlert(message: "You LOSE T_T")
            reset()
        } else if randomValue > hitValue {
            slider.minimumValue = Float(hitValue)
            minimumValueLabel.text = String(hitValue)
        } else if randomValue < hitValue {
            slider.maximumValue = Float(hitValue)
            maximumValueLabel.text = String(hitValue)
        }
    }
    
    @IBAction func touchUpResetButton(_ sendor: UIButton){
        print("touch up reset button")
        reset()
    }
    
    func reset(){
        print("RESET!")
        randomValue = Int.random(in: 0...30)
        print(randomValue)
        
        tryCount = 0
        tryCountLabel.text = "0 / 5"
        
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.value = 15
        minimumValueLabel.text = "0"
        maximumValueLabel.text = "30"
        sliderValueLabel.text = "15"
    }
}

