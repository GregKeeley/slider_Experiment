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
    @IBOutlet weak var sliderStackView: UIStackView!
    
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
    
    var currentGameScore: Float = 0.0 {
        didSet {
            scoreLabel.text = ("\(currentGameScore.rounded())")
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
    override func viewDidAppear(_ animated: Bool) {
        //        sliderStackView.transform = CGAffineTransform.init(rotationAngle: .pi/2)
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
                }
            }
        } else {
            timer.invalidate()
        }
    }
    private func animateSliderImage(slider: UISlider) {
        let duration = 1.0
        let climbRate: Float = 3.0
        switch slider {
        case slider1:
            checkSliderValue(slider: slider1)
            UIView.animate(withDuration: duration, animations: {
                slider.setValue(self.slider1.value + climbRate, animated: true)
            })
        case slider2:
            checkSliderValue(slider: slider2)
            UIView.animate(withDuration: duration, animations: {
                slider.setValue(self.slider2.value + climbRate, animated: true)
            })
        case slider3:
            checkSliderValue(slider: slider3)
            UIView.animate(withDuration: duration, animations: {
                slider.setValue(self.slider3.value + climbRate, animated: true)
            })
        case slider4:
            checkSliderValue(slider: slider4)
            UIView.animate(withDuration: duration, animations: {
                slider.setValue(self.slider4.value + climbRate, animated: true)
            })
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
        var min: Float = 0.0
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                switch slider {
                case slider1:
                    if slider.value > slider1MaxValue {
                        slider1MaxValue = slider.value
                    }
                case slider2:
                    if slider.value > slider1MaxValue {
                        slider2MaxValue = slider.value
                    }
                case slider3:
                    if slider.value > slider1MaxValue {
                        slider3MaxValue = slider.value
                    }
                case slider4:
                    if slider.value > slider1MaxValue {
                        slider4MaxValue = slider.value
                    }
                default:
                    return
                }
            case .ended:
                min = slider.value
                switch slider {
                case slider1:
                    currentGameScore = (currentGameScore + (slider1MaxValue - min))
                case slider2:
                    currentGameScore = (currentGameScore + (slider2MaxValue - min))
                case slider3:
                    currentGameScore = (currentGameScore + (slider3MaxValue - min))
                case slider4:
                    currentGameScore = (currentGameScore + (slider4MaxValue - min))
                default:
                    return
                }
            default:
                break
            }
        }
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

