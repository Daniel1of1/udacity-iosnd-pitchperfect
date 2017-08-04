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
        configureUI(isRecording: false)
    }
    
    //MARK: UI
    
    func configureUI(isRecording:Bool) {
        recordButton.isEnabled = !isRecording
        stopRecordButton.isEnabled = isRecording
        recordingLabel.text = isRecording ? "Recording In Progress" : "Tap to record"
    }
    
    //MARK: Actions
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        startRecording()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
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
            let alert = UIAlertController(title: "Oh no!", message: "Looks like there was an error in recording", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
