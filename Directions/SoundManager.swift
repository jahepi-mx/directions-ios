//
//  SoundManager.swift
//  PTScanner
//
//  Created by Javier Hernández Pineda on 05/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    private var successAudio: AVAudioPlayer = AVAudioPlayer()
    private var errorAudio: AVAudioPlayer = AVAudioPlayer()
    private var scannerAudio: AVAudioPlayer = AVAudioPlayer()
    
    init() {
        
        let successUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("success", ofType: "mp3")!)
        let errorUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("error", ofType: "mp3")!)
        let scannerUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("scanner", ofType: "mp3")!)
        
        do {
            successAudio = try AVAudioPlayer(contentsOfURL: successUrl)
        } catch {
            print("Success sound was not found")
        }
        do {
            errorAudio = try AVAudioPlayer(contentsOfURL: errorUrl)
        } catch {
            print("Error sound was not found")
        }
        do {
            scannerAudio = try AVAudioPlayer(contentsOfURL: scannerUrl)
        } catch {
            print("Scanner sound was not found")
        }
    }
    
    func playSuccess() -> Void {
        successAudio.play()
    }
    
    func playError() -> Void {
        errorAudio.play()
    }
    
    func playScanner() -> Void {
        scannerAudio.play()
    }
}