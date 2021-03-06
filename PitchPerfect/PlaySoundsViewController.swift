//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Daniel Haight on 01/08/2017.
//  Copyright © 2017 Daniel Haight. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0
        case fast
        case chipmunk
        case vader
        case echo
        case reverb
    }
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch ButtonType(rawValue: sender.tag)! {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate:1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch:-1000)
        case .echo:
            playSound(echo:true)
        case .reverb:
            playSound(reverb:true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopAudio()
    }
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    //Mark: UI
    func setupButtons() {
        [
            snailButton,
            chipmunkButton,
            rabbitButton,
            vaderButton,
            echoButton,
            reverbButton,
            stopButton
        ].forEach { (button) in
            button.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    
}
