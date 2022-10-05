//
//  Player.swift
//  Gems Game Testing
//
//  Created by vLinkD on 15/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import AVFoundation
import Foundation

class Player {
    static var player: AVAudioPlayer = AVAudioPlayer()

    @discardableResult static func playSound(named soundName: String, _ isPhonePlay: String? = nil) -> AVAudioPlayer {
        let audioPath = Bundle.main.path(forResource: soundName, ofType: "mp3")
        player = try! AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        if isPhonePlay != nil {
            player.play()
            player.play()
        }

        guard let sound = UserDefaults.standard.string(forKey: "sound"), sound == "ON" else {
            return player
        }
        player.play()
        return player
    }

    static func phoneVibrate(_ isPhoneVibrate: String? = nil) {
        if isPhoneVibrate != nil {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return
        }
        guard let sound = UserDefaults.standard.string(forKey: "vibrate"), sound == "ON" else {
            return
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

/*
 else if touchSelectedNodes.contains(gemView) && shouldSelect(gem: gemView) && (gemView != touchSelectedNodes.last)  {
 print("enter make pair")
 //  print("make pair",touchSelectedNodes.last?.loc)
 // delegate?.updateProgressBar(-1, selectedColor)
 //touchSelectedNodes.removeLast()
 makePerfectPair = true
 touchSelectedNodes.append(gemView)
 gemView.addPulse(fillColor: gemView.backgroundColor ?? .white)
 delegate?.updateProgressBar(1, gemView.backgroundColor ?? .white)
 } else if touchSelectedNodes.contains(gemView) && shouldSelect(gem: gemView) &&  (gemView == touchSelectedNodes.last) {
 print("remove")
 lastLayer.removeFromSuperlayer()
 delegate?.updateProgressBar(-1, selectedColor)
 touchSelectedNodes.removeLast()
 //touchSelectedNodes.append(gemView)
 // gemView.addPulse(fillColor: gemView.backgroundColor ?? .white)
 //delegate?.updateProgressBar(1, gemView.backgroundColor ?? .white)
 }

 */
