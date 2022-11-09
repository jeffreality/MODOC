//
//  FaceManager.swift
//  MODOC
//
//  Created by Jeffrey Berthiaume on 10/13/22.
//

import UIKit

// manages the MODOC face animations

enum FaceTypes {
    case rest
    case talk
}

class FaceManager {
    static let shared = FaceManager()
    
    let restingImages = [
        UIImage(named: "modok_rest_frame_01"),
        UIImage(named: "modok_rest_frame_02"),
        UIImage(named: "modok_rest_frame_03"),
        UIImage(named: "modok_rest_frame_04")
    ]
    
    let talkingImages = [
        UIImage(named: "modok_talk_frame_01"),
        UIImage(named: "modok_talk_frame_02"),
        UIImage(named: "modok_talk_frame_03"),
        UIImage(named: "modok_talk_frame_04"),
        UIImage(named: "modok_talk_frame_05")
    ]
    
    var restingIdx: Int = 0
    var talkingIdx: Int = 0
    
    func getRestingFace() -> UIImage? {
        restingIdx += 1
        if restingIdx == restingImages.count {
            restingIdx = 0
        }
        return restingImages[restingIdx]
    }
    
    func getTalkingFace() -> UIImage? {
        talkingIdx += 1
        if talkingIdx == talkingImages.count {
            talkingIdx = 0
        }
        return talkingImages[talkingIdx]
    }
}
