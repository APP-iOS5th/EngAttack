//
//  SoundSetting.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 5/2/24.
//

import SwiftUI
import AVKit

class SoundSetting_: ObservableObject {
    
    @Published var isEffect: Bool = false
    @Published var backVol: Float = 0.0
    
    var currentVolume: Float = 0.0
    
    static let instance = SoundSetting()
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case correct
        case error
        case background
    }
    
    func playSound(sound: SoundOption/*, volume: Float*/) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = currentVolume
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
    
    func setVolume(_ volume: Float) {
        currentVolume = volume
    }
}
