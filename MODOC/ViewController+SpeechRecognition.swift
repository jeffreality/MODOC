//
//  ViewController+SpeechRecognition.swift
//  MODOC
//
//  Created by Jeffrey Berthiaume on 11/9/22.
//  Speech Recognition

import UIKit
import Speech

extension ViewController {
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.", authStatus.rawValue)
                }
            }
        }
    }
    
    func startAudio() {
        print ("start listening to audio")
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print ("an audio session error has occurred")
        }
    }
    
    func startListening() {
        UIView.animate(withDuration: 1.0) {
            self.subtitleLabel?.isHidden = true
        }
        print ("startListening")
        if self.speechRecognizer.isAvailable {
            // Use the speech recognizer
            do {
                try startRecording()
            } catch {
                print ("Error with recording")
            }
        }
    }
    
    func startRecording() throws {
        print ("startRecording")
        node = audioEngine.inputNode
        let recordingFormat = node?.outputFormat(forBus: 0)
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        node?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer.recognitionTask(with: self.recognitionRequest) { result, error in
            if let result = result {
                if !self.hasStartedTalking {
                    print ("hasStartedTalking")
                    self.hasStartedTalking = true
                    
                    self.talkingTimer = Timer.scheduledTimer(timeInterval: self.pauseTime, target: self, selector: #selector(self.didFinishTalk), userInfo: nil, repeats: false)
                } else {
                    print ("timer restart")
                    self.talkingTimer.invalidate()
                    self.talkingTimer = Timer.scheduledTimer(timeInterval: self.pauseTime, target: self, selector: #selector(self.didFinishTalk), userInfo: nil, repeats: false)
                }
                
                print ("addingToTalkString")
                self.talkString = result.bestTranscription.formattedString
                
                if self.hasFinishedTalking {
                    print ("hasFinishedTalking")
                    self.talkingTimer.invalidate()
                    self.hasFinishedTalking = false
                    self.hasStartedTalking = false
                }
                
            }
        }
    }
    
    @objc func didFinishTalk() {
        print ("didFinishTalk")
        hasStartedTalking = false
        hasFinishedTalking = true
        self.sendUserMessage(str: talkString.lowercased())
        self.cancelRecording()
        talkString = ""
    }
    
    func cancelRecording() {
        print ("cancelRecording")
        node?.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionRequest.endAudio()
        recognitionTask?.cancel()
    }
    
}


extension ViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            FaceManager.shared.faceType = .rest
            self.startListening()
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            FaceManager.shared.faceType = .talk
            
            let str = String(utterance.speechString)
            let range = Range(characterRange, in: str)!
            
            self.subtitleLabel?.text = (self.subtitleLabel?.text ?? "") + " " + str[range]
        }
        
    }
}

extension ViewController: SFSpeechRecognizerDelegate {
    
}
