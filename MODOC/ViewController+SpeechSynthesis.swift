//
//  ViewController+SpeechSynthesis.swift
//  MODOC
//
//  Created by Jeffrey Berthiaume on 11/9/22.
//  Text to Speech

import UIKit
import Speech

extension ViewController {
    
    func speak(_ speechString: String) {
        var str = speechString
        
        // replace any internal values
        for (key, val) in valuesHeard {
            str = str.replacingOccurrences(of: "%%\(key)%%", with: val)
        }
        
        print ("MODOC: \(str)\n")
        
        subtitleLabel?.text = ""
        subtitleLabel?.isHidden = false
        
        let speechUtterance = AVSpeechUtterance(string: str)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: locale)
        speechUtterance.volume = 1.0
        speechUtterance.rate = 0.5
        speechUtterance.pitchMultiplier = 0.1
        
        speechSynthesizer.speak(speechUtterance)
    }
    
}
