//
//  SettingView.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 4/30/24.
//

import SwiftUI
import AVKit

class SoundSetting: ObservableObject {
    
    // 싱글톤
    static let instance = SoundSetting()
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case correct
        case error
        case background
    }
    
    func playSound(sound: SoundOption, volume: Float) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volume
            player?.play()
        } catch let error {
            print("재생하는데 오류가 발생했습니다. \(error.localizedDescription)")
        }
    }
}

struct SettingView: View {
    @State var isDarkMode = false
    @State var isEffect = false
    @State var volume = 0.0
    @State var settingsSound = false
    
    var body: some View {
        VStack {
            Text("설정")
                .font(.largeTitle)
                .bold()
            List {
                Toggle(isOn: $isDarkMode) {
                    Text(isDarkMode ? "라이트모드" : "다크모드")
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                    
                }
                DisclosureGroup("음향", isExpanded: $settingsSound) {
                    Toggle(isOn: $isEffect) {
                        Text(isEffect ? "효과음 OFF" : "효과음 ON")
                        
                    }
                    HStack {
                        Text("배경음")
                            .padding(.trailing)
                        Spacer()
                        Slider(value: $volume, in: 0...100, step: 1)
                            .onChange(of: volume) {
                                SoundSetting.instance.playSound(sound: .background, volume: Float(volume) * 0.05)
                            }
                    }
                }
                // TODO: test용 버튼 삭제 필요
                Button {
                    print(isEffect)
                    isEffect ? SoundSetting.instance.playSound(sound: .background, volume: Float(volume)) : SoundSetting.instance.playSound(sound: .background, volume: Float(volume))
                } label: {
                    Image(systemName: "circle.fill")
                }
                
                Button {
                    //some action 2
                } label: {
                    Image(systemName: "square.fill")
                }
                
            }
            .font(.system(size: 20))
            .bold()
        }
    }
}

#Preview {
    SettingView()
}
