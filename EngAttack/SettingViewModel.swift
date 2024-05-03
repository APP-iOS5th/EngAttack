//
//  SettingViewModel.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 5/2/24.
//

import SwiftUI
import AVKit

class SettingViewModel: ObservableObject {
    @Published var isEffect: Bool = true
    @Published var backVol: Float = 50.0
}


class SoundSetting: ObservableObject {
    
    var currentVolume: Float = 0.0
    
    static let instance = SoundSetting()
    
    var players: [AVAudioPlayer] = []
    
    enum SoundOption: String {
        case correct
        case error
        case background
    }
    
    func playSound(sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else { return }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = currentVolume
            player.play()
            players.append(player)
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
    
    func stopMusic() {
        players.forEach { $0.stop() }
        players.removeAll()
    }
    
    func setVolume(_ volume: Float) {
        currentVolume = volume
        players.forEach { $0.volume = volume }
    }
}
