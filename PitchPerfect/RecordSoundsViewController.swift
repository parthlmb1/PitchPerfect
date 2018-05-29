//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Parth Lamba on 03/12/17.
//  Copyright © 2017 Parth Lamba. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //AVAudioRecorderDelegate is a Seperate class that helps us to delegate
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    //In swift ; is not important after every statement
    //Their usage is optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //isEnabled property tells the view that weather the button should be clickable when the view appears
        //This property has a boolean value i.e. it only takes TRUE/ FALSE as its values
        
        recordButton.isEnabled = true
        //Here TRUE is passed as value so the button will be clickable when the view is finished loading and appears on the screen
        
        
        stopRecordButton.isEnabled = false
        //Here FLASE is passed as value so the button will not be clickable when the view is finished loading and appeared on the screen.
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("viewWillAppear function is Called!!")
        //This function is called just before the View is about to appear on the screen
    }*/
    
    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("ViewDidAppear function is Called!!")
        //This function is called just before the View appears on the screen
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordButton(_ sender: Any) {
        /* 
            * print("Button Pressed")
            * The Above Function is Used to Print Something/ Logs to the console window
            * When the record Button is pressed this Function prints to the console window 
            * @IBAction is used to link an event to the code/ Functionality i.e in our case it link the pressing of button <Event> to printing to the console <Code/ Functionality>.
            * Printing is called caveMan debugging as it is the oldest way of degugging
        */
        
        recordLabel.text = "Recording in Pregress..."
        //TEXT property is used to set/ get the value of the text box
        
        recordButton.isEnabled = false
        stopRecordButton.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        //Make a directory path to save the file
        
        let recordingName = "recordedVoice.wav"
        //File name for the recorded file
        
        let pathArray = [dirPath, recordingName]
        //combines the directory and the file name
        
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //takes the file path as String and sets it as URL to the location.
        
        //print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        //Creates the session for recording the file
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        //make speakers as default for intake of voice
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecordButton(_ sender: Any) {
        recordLabel.text = "Press to Record"
        recordButton.isEnabled = true
        stopRecordButton.isEnabled = false
        
        audioRecorder.stop()
        //Stops the recording 
        
        let audioSession = AVAudioSession.sharedInstance()
        // sets the audio session as shared Instance
        
        try! audioSession.setActive(false)
        //Sets the session as InActive or destroys the session
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //print("Audio Recorded")
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            //print("Audio Recorded")

        } else {
            print("Recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            //segue.identifier == "stopRecordig" checks if there is a segue named stop Recording
            
            let playSoundsVC =  segue.destination as! PlaySoundsViewController
            // creates the designation as PlaySoundsViewController || playSoundsVC is a Object of PlaySoundsViewController
            
            let recordedAudioPath = sender as! URL
            //Takes the recorded audio file path and assign it to recordedAudioURL
            
            playSoundsVC.recordedAudioURL = recordedAudioPath
            //assign the path to the recordedAudioURL whch is a Property in PlaySoundsViewController
        }
    }
}

