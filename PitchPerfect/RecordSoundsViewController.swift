//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Daniel Haight on 31/07/2017.
//  Copyright © 2017 Daniel Haight. All rights reserved.
//

import UIKit

import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(.stopped)
    }
    
    //MARK: UI
    
    enum RecordingState {
        case recording
        case stopped
    }
    
    func configureUI(_ recordingState:RecordingState) {
        switch recordingState {
        case .recording:
            configureUIForRecording()
        case .stopped:
            configureUIForStopped()
        }
    }
    
    func configureUIForRecording() {
        recordButton.isEnabled = false
        stopRecordButton.isEnabled = true
        recordingLabel.text = "Recording In Progress"
    }
    
    func configureUIForStopped() {
        recordButton.isEnabled = true
        stopRecordButton.isEnabled = false
        recordingLabel.text = "Tap to record"
    }
    
    //MARK: Actions
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(.recording)
        startRecording()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(.stopped)
        stopAudioSession()
    }
    
    //MARK: Audio
    
    func startRecording() {
        // create path
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recordingName = "recordedVoice.wav"
        let pathAarray = [dirPath, recordingName]
        let path = pathAarray.joined(separator: "/")
        let fileURL = URL(string:path)!
        
        // set up session for playing / recording
        // i.e setting some global state
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        // create/set audioRecorder
        try! audioRecorder = AVAudioRecorder(url:fileURL, settings:[:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopAudioSession() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL // why not a variable instead of using sender
            playSoundsVC.recordedAudioURL = recordedAudioURL
        
        }
    }
    
}

// MARK: - AVAudioRecorderDelegate
extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording failed")
        }
    }
    
}
