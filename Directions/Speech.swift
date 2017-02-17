//
//  Speech.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 22/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//
import AVFoundation
import Foundation

class Speech {
    
    private var synth = AVSpeechSynthesizer()
    private var utterance = AVSpeechUtterance(string: "")
    private var voiceToUse: AVSpeechSynthesisVoice?
    
    // Singleton pattern, to share this instance between view controllers
    static let getInstance = Speech()
    
    init() {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if voice.name == "Monica" {
                voiceToUse = voice
            }
        }
    }
    
    func speak(message: String) {
        utterance = AVSpeechUtterance(string: message)
        utterance.voice = voiceToUse
        utterance.rate = 0.4
        synth.speakUtterance(utterance)
    }
}