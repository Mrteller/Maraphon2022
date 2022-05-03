//
//  ViewController.swift
//  TimeRemaining
//
//  Created by Paul on 03.05.2022.
//

import UIKit

enum Status: CaseIterable {
    case correct, incorrect, elapsed, waiting
}

class State {
    init(status: Status, updater: ((Status) -> Void)? = nil, timeRemaining: Int = 60) {
        self.status = status
        self.updater = updater
        self.timeRemaining = timeRemaining
    }
    
    var status: Status {
        didSet {
            if case .waiting = status {
                timeRemaining = 60
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    self.updater?(self.status)
                    if self.timeRemaining == 0 {
                        timer.invalidate()
                        self.status = .incorrect
                    }
                    self.timeRemaining -= 1
                }
                timer?.tolerance = 0.2
            } else {
                self.updater?(self.status)
            }
        }
    }
    var updater: ((Status) -> Void)?
    var timeRemaining = 60
    private var timer: Timer?
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    
    var status: Status = .waiting{
        didSet {
            if case .waiting = status {
                timeRemaining = 60
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    self.updater?(self.status)
                    if self.timeRemaining == 0 {
                        timer.invalidate()
                        self.status = .elapsed
                    }
                    self.timeRemaining -= 1
                }
                timer?.tolerance = 0.2
            } else {
                timer?.invalidate()
                updater?(self.status)
            }
        }
    }
    var updater: ((Status) -> Void)?
    var timeRemaining = 60
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updater = { status in
            switch status {
            case .correct:
                self.timeRemainingLabel.text = "Correct"
            case .incorrect:
                self.timeRemainingLabel.text = "Incorrect"
            case .waiting:
                self.timeRemainingLabel.text = "Time remaining: \(self.timeRemaining)"
            case .elapsed:
                self.timeRemainingLabel.text = "Time elapsed"
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        status = .waiting
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {

    }
    

    
}
