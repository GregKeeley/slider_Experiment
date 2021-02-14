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
    var slider1ScoreValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider1)
            checkSliderValue(slider: slider1)
        }
    }
    var slider2ScoreValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider2)
            checkSliderValue(slider: slider2)
        }
    }
    var slider3ScoreValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider3)
            checkSliderValue(slider: slider3)
        }
    }
    var slider4ScoreValue: Float = 0.0 {
        didSet {
            animateSliderImage(slider: slider4)
            checkSliderValue(slider: slider4)
        }
    }
    var currentScore: Float = 0.0 {
        didSet {
            scoreLabel.text = ("\(currentScore)")
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

    }
        
     //MARK:- Functions
    func setupSlider(_ slider: UISlider) {
        
    }
    private func reduceScore() {
        let scores = [slider1ScoreValue, slider2ScoreValue, slider3ScoreValue, slider4ScoreValue]
        let totalScore = scores.reduce(0, { x, y in
            x + y
        })
        currentScore = totalScore
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
                    self.slider1ScoreValue += 1
                    self.slider2ScoreValue += 1
                    self.slider3ScoreValue += 1
                    self.slider4ScoreValue += 1
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
            slider.setValue(slider1ScoreValue, animated: true)
        case slider2:
            checkSliderValue(slider: slider2)
            slider.setValue(slider2ScoreValue, animated: true)
        case slider3:
            checkSliderValue(slider: slider3)
            slider.setValue(slider3ScoreValue, animated: true)
        case slider4:
            
            slider.setValue(slider4ScoreValue, animated: true)
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
            slider.setValue(0, animated: true)
        }
    }
     //MARK:- @IBActions
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        currentScore = 0
        slider1ScoreValue = 0
        slider2ScoreValue = 0
        slider3ScoreValue = 0
        slider4ScoreValue = 0
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

