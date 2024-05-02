//
//  SettingView.swift
//  EngAttack
//
//  Created by JIHYE SEOK on 4/30/24.
//

import SwiftUI
import AVKit

struct SettingView: View {
    @EnvironmentObject var viewModel: ContentViewViewModel
    @EnvironmentObject var setViewModel: SettingViewModel
    
    @State var settingsSound = false
    @State var backVolume = 0.0
    let effectVol = 0.3
    
    var body: some View {
        VStack {
            // Title
            Text("설정")
                .font(.system(size: 25))
                .bold()
            Form {
                // MARK: 마이페이지
                Section(header: Text("마이페이지").font(.system(size: 18))) {
                    Button {
                        // TODO: 회원정보 수정 페이지 이동
                        print("mypage view")
                    } label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text("닉네임이 들어가요~")
                                .foregroundStyle(viewModel.isDarkMode ? .white : .black)
                                .padding(.leading, 5)
                                .fontWeight(.semibold)
                                .font(.system(size: 21))
                        }
                        .frame(height: 70)
                    }
                }
                // MARK: 환경 설정
                Section(header: Text("환경설정").font(.system(size: 18))) {
                    Toggle(isOn: $viewModel.isDarkMode) {
                        Text(viewModel.isDarkMode ? "라이트모드" : "다크모드")
                    }
                    DisclosureGroup("음향", isExpanded: $settingsSound) {
                        Toggle(isOn: $setViewModel.isEffect) {
                            Text(setViewModel.isEffect ? "효과음 OFF" : "효과음 ON")
                        }
                        HStack {
                            Text("배경음")
                                .padding(.trailing)
                            Spacer()
                            Slider(value: $backVolume, in: 0...100, step: 1)
                                .onChange(of: backVolume) {
                                    SoundSetting.instance.playSound(sound: .background/*, volume: Float(backVolume) * 0.1*/)
                                }
                        }
                    }
                }
            }
        }
        //.preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
        .font(.system(size: 20))
        
    }
}

#Preview {
    SettingView()
        .environmentObject(ContentViewViewModel())
        .environmentObject(SettingViewModel())
}
