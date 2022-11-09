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
    
    var animTime: TimeInterval = 0.1
    var faceType: FaceTypes = .rest
    var faceImage: UIImageView?
    
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
    
    @objc func animateFace() {
        // helper method to get the next appropriate animate for the animation timer
        switch faceType {
            case .talk:
                faceImage?.image = getTalkingFace()
            default: // .rest
                faceImage?.image = getRestingFace()
        }
    }
    
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
