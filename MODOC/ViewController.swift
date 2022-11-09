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
    
    // Dialogue (conversational management)
    var goodbyeHeard: Bool = true // when true, can only be woken with "Hello MODOC"
    var unaskedQuestionsIndexes: [Int] = [] // index within Dialogue.shared.dialogue
    var currentQuestion: Dialogue?
    var valuesHeard: [String: String] = [:]
    
    // Face animation
    var faceAnimationTimer: Timer = Timer()
    var faceManager = FaceManager.shared
    
    // UI
    @IBOutlet var faceImage: UIImageView?
    @IBOutlet var subtitleLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer.delegate = self
        speechSynthesizer.delegate = self
        
        speechSynthesizer.usesApplicationAudioSession = true
        
        requestTranscribePermissions()
        
        startAudio()
        
        FaceManager.shared.faceImage = faceImage
        
        faceAnimationTimer = Timer.scheduledTimer(timeInterval: faceManager.animTime, target: faceManager, selector: #selector(faceManager.animateFace), userInfo: nil, repeats: true)
        
        DispatchQueue.main.async {
            self.startListening()
        }
        
    }

}
