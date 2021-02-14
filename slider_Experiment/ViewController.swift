//
//  ViewController.swift
//  slider_Experiment
//
//  Created by Gregory Keeley on 2/14/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var slider4: UISlider!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startTimerButton: UIButton!
    
     //MARK:- Variable and Constants
    var slider1MaxValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider1)
            checkSliderValue(slider: slider1)
        }
    }
    var slider2MaxValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider2)
            checkSliderValue(slider: slider2)
        }
    }
    var slider3MaxValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider3)
            checkSliderValue(slider: slider3)
        }
    }
    var slider4MaxValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider4)
            checkSliderValue(slider: slider4)
        }
    }
    var slider1MinValue: Float = 0.0
    var slider2MinValue: Float = 0.0
    var slider3MinValue: Float = 0.0
    var slider4MinValue: Float = 0.0
    
    var currentGameScore: Float = 0.0 {
        didSet {
            scoreLabel.text = ("\(currentGameScore)")
        }
    }
    
    // Timer
    var timerIsPaused: Bool = true
    var timer = Timer()
    var seconds: Int = 0 {
        didSet {
            if seconds < 10 && minutes < 10 {
            timerLabel.text = ("0\(minutes):0\(seconds)")
            } else if seconds < 10 && minutes >= 10 {
                timerLabel.text = ("\(minutes):0\(seconds)")
            } else {
                timerLabel.text = ("0\(minutes):\(seconds)")
            }
        }
    }
    var minutes: Int = 0 {
        didSet {
            if minutes < 10 {
                timerLabel.text = ("0\(minutes):0\(seconds)")
            } else {
                timerLabel.text = ("\(minutes):0\(seconds)")
            }
        }
    }
    
     //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        slider1.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        slider2.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        slider3.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        slider4.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)

    }
        
     //MARK:- Functions
    func setupSlider(_ slider: UISlider) {
        
    }
    private func reduceScore() {
        let scores = [slider1MaxValue, slider2MaxValue, slider3MaxValue, slider4MaxValue]
        let totalScore = scores.reduce(0, { x, y in
            x + y
        })
        currentGameScore = totalScore
    }
    private func startTimer() {
        timerIsPaused.toggle()
        if timerIsPaused == false {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tempTimer in
                if self.seconds == 59 {
                    self.seconds = 00
                    if self.minutes == 59 {
                        self.minutes = 00
                    } else {
                        self.minutes = self.minutes + 1
                    }
                } else {
                    self.seconds = self.seconds + 1
                    self.animateSliderImage(slider: self.slider1)
                    self.animateSliderImage(slider: self.slider2)
                    self.animateSliderImage(slider: self.slider3)
                    self.animateSliderImage(slider: self.slider4)
                    self.reduceScore()
                }
            }
        } else {
            timer.invalidate()
        }
    }
    private func animateSliderImage(slider: UISlider) {
        switch slider {
        case slider1:
            checkSliderValue(slider: slider1)
            slider.setValue(slider1.value + 1, animated: true)
        case slider2:
            checkSliderValue(slider: slider2)
            slider.setValue(slider2.value + 1, animated: true)
        case slider3:
            checkSliderValue(slider: slider3)
            slider.setValue(slider3.value + 1, animated: true)
        case slider4:
            checkSliderValue(slider: slider4)
            slider.setValue(slider4.value + 1, animated: true)
        default:
            return
        }
        self.view.layoutIfNeeded()
        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
        }
        animator.startAnimation()
    }
    private func checkSliderValue(slider: UISlider) {
        if slider.value == slider.maximumValue {
            slider.isEnabled = false
        } else {
            slider.isEnabled = true
        }
    }
     //MARK:- @IBActions
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        var max: Float = 0.0
        var min: Float = 0.0
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began: 
                // handle drag began
                print("Began: \(slider.value)")
                max = slider.value
            case .moved:
                // handle drag moved
            print("moving")
            case .ended:
                // handle drag ended
                print("Ended: \(slider.value)")
                min = slider.value
            default:
                break
            }
        }
        currentGameScore = (currentGameScore + (max - min))
        slider.setValue(min, animated: true)
    }
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        currentGameScore = 0
        slider1MaxValue = 0
        slider2MaxValue = 0
        slider3MaxValue = 0
        slider4MaxValue = 0
        timerLabel.text = "00:00"
        timer.invalidate()
    }
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startTimer()
        if timerIsPaused {
            startTimerButton.setTitle("Start", for: .normal)
        } else {
            startTimerButton.setTitle("Stop", for: .normal)
        }
    }
}

