//
//  MODOCViewController.swift
//  MODOC
//
//  Created by Jeffrey Berthiaume on 10/9/22.
//

import UIKit
import Speech

class MODOCViewController: UIViewController {
    
    // Speech recognition
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()!
    var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var speechSynthesizer = AVSpeechSynthesizer()
    var node: AVAudioInputNode?
    var locale: String = "us-EN"
    
    var talkString: String = ""
    var talkingTimer: Timer?
    var pauseTime: TimeInterval = 0.8
    
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
        
        requestTranscribePermissions()
        
        startAudio()
        
        FaceManager.shared.faceImage = faceImage
        
        faceAnimationTimer = Timer.scheduledTimer(timeInterval: faceManager.animTime, target: faceManager, selector: #selector(faceManager.animateFace), userInfo: nil, repeats: true)
        
    }

}
