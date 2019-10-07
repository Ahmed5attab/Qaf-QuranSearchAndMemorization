
//
//  QuranReadingViewController.swift
//  Quran
//
//  Created by Ahmed khattab on 3/20/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import Speech

class QuranReadingViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var SuraVersesTextView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ar-SA"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var selectedVerses = ""
    var selectedVersesWithoutTashkel = ""
    var from = 0
    var to = 0
    var suraName = ""
    var ChapterID: String?
    var userSayingArray: [String] = []
    var tempArray : [String] = []
    var retriev = ""
    var versesplus = ""
    var ArrayA : [String] = []
    var ArrayB : [String] = []
    var arr : [String] = []
    var finalResult : String = ""
    var flagButton = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        SuraVersesTextView.text = selectedVerses
        suraNameLabel.text = suraName
        chapterNumberLabel.text = " الجزء (\(ChapterID!))"
        
        microphoneButton.isEnabled = false
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .notDetermined:
                isButtonEnabled = false
                print("not authorized yet\n")
            case .denied:
                isButtonEnabled = false
                print("user denied access to speech recognition\n")
            case .restricted:
                isButtonEnabled = false
                print("speech recognition is restricted on this device")
            }
            
            OperationQueue.main.addOperation {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        
    }
    
    
    @IBAction func onClickStartRecitationButton(_ sender: UIButton) {
        performUIUpdatesOnMain {
            self.SuraVersesTextView.text = nil
        }
        
        retriev = GetVerses(SoraName: suraName, start: from, end: to, flag: 0)
        print("this is retriev " + retriev)
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setImage(UIImage(named: "Record.png"), for: .normal)
            SuraVersesTextView.isEditable = true
            self.flagButton = false
            microphoneButton.setTitle("confirm", for: .normal)
            
        } else if (audioEngine.isRunning == false  && self.flagButton == true) {
            print(" this is " , self.flagButton)
            startRecording()
            microphoneButton.setImage(UIImage(named: "Stop.png"), for: .normal)
            self.flagButton = false
            microphoneButton.setTitle("Stop", for: .normal)
            
        }
        else if (audioEngine.isRunning == false && self.flagButton == false ){
            userSayingArray = (SuraVersesTextView.text).components(separatedBy: " ")
            print("this is user sayes " , userSayingArray)
            let correctUserWords = self.longestCommonSubsequence(self.userSayingArray, sec: self.selectedVersesWithoutTashkel.components(separatedBy: " "))
            microphoneButton.isHidden = true
            
            let quranReadingVC = self.storyboard?.instantiateViewController(withIdentifier: "QuranResult") as? QuranResultViewController
            quranReadingVC?.Verses = self.selectedVersesWithoutTashkel.components(separatedBy: " ")
            quranReadingVC?.RecitationVerses = correctUserWords
            quranReadingVC?.suraName = self.suraName
            quranReadingVC?.ChapterID = self.ChapterID
            self.navigationController?.pushViewController(quranReadingVC!, animated: true)
            
        }
    }
    
    
    func startRecording(){
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch {
            print("audioSession properties weren't set because of an error")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: {(result, error) in
            var isFinal = false
            if result != nil {
                
                self.SuraVersesTextView.text = (result?.bestTranscription.formattedString)!
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine Couldn't start because of an error")
        }
        
        SuraVersesTextView.text = "Start Recitating.."
    }
    
    
    
}



extension QuranReadingViewController {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        }
        else {
            microphoneButton.isEnabled = false
        }
    }
}


