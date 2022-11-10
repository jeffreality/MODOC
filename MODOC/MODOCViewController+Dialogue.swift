//
//  MODOCViewController+Dialogue.swift
//  MODOC
//
//  Created by Jeffrey Berthiaume on 11/9/22.
//  This manages the text strings for conversational back-and-forth.

import UIKit

extension MODOCViewController {
    
    func sendUserMessage(str: String) {
        // check to see if the last question had been asked or goodbye was heard, and terminate the session
        // otherwise, ask the next (random) question in the queue
        
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
        // ask a question/line of dialogue, wait for answer
        
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
