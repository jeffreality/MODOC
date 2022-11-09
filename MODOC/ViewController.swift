//
//  ViewController.swift
//  MODOC
//
//  Created by Jeffrey Berthiaume on 10/9/22.
//

import UIKit
import Speech

class ViewController: UIViewController {
    
    // Speech recognition
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()!
    var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var speechSynthesizer = AVSpeechSynthesizer()
    var talkString: String = ""
    var hasStartedTalking: Bool = false
    var hasFinishedTalking: Bool = false
    var talkingTimer: Timer = Timer()
    var pauseTime: TimeInterval = 0.8
    var node: AVAudioInputNode?
    var locale: String = "us-EN"
    
    var goodbyeHeard: Bool = true // when true, can only be woken with "Hello MODOC"
    var unaskedQuestionsIndexes: [Int] = [] // index within Dialogue.shared.dialogue
    var currentQuestion: Dialogue?
    
    var valuesHeard: [String: String] = [:]
    
    
    var subtitleLabel = UILabel()
    
    // Face animation
    var faceAnimationTimer: Timer = Timer()
    var animTime: TimeInterval = 0.1
    var faceType: FaceTypes = .rest
    @IBOutlet var faceImage: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subtitleLabel.frame = CGRect(x: 20, y: view.frame.height - 100 - 200, width: self.view.frame.width - 40, height: 180)
        subtitleLabel.font = UIFont.systemFont(ofSize: 40.0)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .white
        self.view.addSubview(subtitleLabel)
        
        speechRecognizer.delegate = self
        speechSynthesizer.delegate = self
        
        speechSynthesizer.usesApplicationAudioSession = true
        
        requestTranscribePermissions()
        
        startAudio()
        
        faceAnimationTimer = Timer.scheduledTimer(timeInterval: animTime, target: self, selector: #selector(self.animateFace), userInfo: nil, repeats: true)
        
        DispatchQueue.main.async {
            self.startListening()
        }
        
    }
    
    @objc func animateFace() {
        switch faceType {
            case .talk:
                faceImage?.image = FaceManager.shared.getTalkingFace()
            default: // .rest
                faceImage?.image = FaceManager.shared.getRestingFace()
        }
    }
    
    func sendUserMessage(str: String) {
        // print to file
        print ("User: \(str)\n")
        
        if goodbyeHeard && (str.contains("hello") || str.contains("modoc")) {
            
            // reset all values
            goodbyeHeard = false
            valuesHeard = [:]
            unaskedQuestionsIndexes = Array(0...DialogueManager.shared.dialogue.count - 1)
            
            askQuestion(prefix: DialogueManager.shared.greetings.shuffled().first)
            return
        }
        
        if goodbyeHeard {
            DispatchQueue.main.async {
                self.startListening()
            }
            return
        }
        
        if let valueRetained = currentQuestion?.valueRetained {
            // store the value for later use
            valuesHeard[valueRetained] = str
        }
        
        // if answer heard, respond and either terminate or ask another question
        if let answers = currentQuestion?.answers {
            for answer in answers {
                for a in answer.answers {
                    if str.contains(a) || a == ""  {
                        // ANSWER received!
                        let response = answer.responses.shuffled().first
                        
                        if answer.shouldTerminate {
                            goodbyeHeard = true
                        }
                        
                        askQuestion(prefix: response)
                        
                        return
                    }
                }
            }
        }
        
    }

    func askQuestion(prefix: String?) {
        // ask a line of dialogue, wait for answer
        
        if goodbyeHeard {
            DispatchQueue.main.async {
                self.speak (prefix ?? "")
            }
            return
        }
        
        // if no questions left, terminate
        if unaskedQuestionsIndexes.count == 0 {
            
            goodbyeHeard = true
            DispatchQueue.main.async {
                self.speak ("I am now tired of talking to you. Send in the next candidate. Goodbye.")
            }
            return
            
        }
        
        // else run the next question
        unaskedQuestionsIndexes = unaskedQuestionsIndexes.shuffled()
        currentQuestion = DialogueManager.shared.dialogue[unaskedQuestionsIndexes.first ?? 0]
        unaskedQuestionsIndexes.removeFirst()
        
        let q = currentQuestion?.questions.shuffled().first
        
        let speech = "\(prefix ?? "") \(q ?? "")"
        
        DispatchQueue.main.async {
            self.speak (speech)
        }
    }

}


/// Speech recognition
extension ViewController {
    
    func speak(_ speechString: String) {
        var str = speechString
        
        // replace any internal values
        for (key, val) in valuesHeard {
            str = str.replacingOccurrences(of: "%%\(key)%%", with: val)
        }
        
        // print to file
        print ("MODOC: \(str)\n")
        
        subtitleLabel.text = ""
        subtitleLabel.alpha = 1.0
        
        let speechUtterance = AVSpeechUtterance(string: str)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: locale)
        speechUtterance.volume = 1.0
        speechUtterance.rate = 0.5
        speechUtterance.pitchMultiplier = 0.1
        
        speechSynthesizer.speak(speechUtterance)
    }
    
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
        print ("startAudio")
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try! audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        try! audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
    }
    
    func startListening() {
        UIView.animate(withDuration: 1.0) {
            self.subtitleLabel.alpha = 0.0
        }
        //print ("startListening")
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
        //print ("startRecording")
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
                    // print ("hasStartedTalking")
                    self.hasStartedTalking = true
                    
                    self.talkingTimer = Timer.scheduledTimer(timeInterval: self.pauseTime, target: self, selector: #selector(self.didFinishTalk), userInfo: nil, repeats: false)
                } else {
                    // print ("timer restart")
                    self.talkingTimer.invalidate()
                    self.talkingTimer = Timer.scheduledTimer(timeInterval: self.pauseTime, target: self, selector: #selector(self.didFinishTalk), userInfo: nil, repeats: false)
                }
                
                // print ("addingToTalkString")
                self.talkString = result.bestTranscription.formattedString
                
                if self.hasFinishedTalking {
                    // print ("hasFinishedTalking")
                    self.talkingTimer.invalidate()
                    self.hasFinishedTalking = false
                    self.hasStartedTalking = false
                }
                
            }
        }
    }
    
    @objc func didFinishTalk() {
        //print ("didFinishTalk")
        hasStartedTalking = false
        hasFinishedTalking = true
        self.sendUserMessage(str: talkString.lowercased())
        self.cancelRecording()
        talkString = ""
    }
    
    func cancelRecording() {
        //print ("cancelRecording")
        node?.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionRequest.endAudio()
        recognitionTask?.cancel()
    }
    
}


extension ViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        faceType = .rest
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.startListening()
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.faceType = .talk
            
            let str = String(utterance.speechString)
            let range = Range(characterRange, in: str)!
            self.subtitleLabel.text = (self.subtitleLabel.text ?? "") + " " + str[range]
        }
        
    }
}

extension ViewController: SFSpeechRecognizerDelegate {
    
}
